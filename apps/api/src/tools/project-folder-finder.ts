import { readdir, stat } from "fs/promises"
import path from "path"
import { existsSync } from "fs"

export interface ProjectFolderResult {
    projectNumber: string
    fullPath: string
    folderName: string
    parentFolder: string
}

/**
 * Recursively search for project folders by project number
 * @param baseDir Base directory to search in
 * @param projectNumber Project number to search for
 * @returns Array of matching project folders
 */
export async function findProjectFolder(
    baseDir: string,
    projectNumber: string | number
): Promise<ProjectFolderResult[]> {
    const results: ProjectFolderResult[] = []
    const projectNum = projectNumber.toString()
    
    if (!existsSync(baseDir)) {
        throw new Error(`Base directory does not exist: ${baseDir}`)
    }
    
    async function searchDirectory(currentDir: string): Promise<void> {
        try {
            const entries = await readdir(currentDir, { withFileTypes: true })
            
            for (const entry of entries) {
                if (!entry.isDirectory()) continue
                
                const fullPath = path.join(currentDir, entry.name)
                
                // Check if folder name starts with the project number
                // Patterns: "1001 name" or "1001-name" or just "1001"
                const folderNameMatch = entry.name.match(/^(\d+)[\s\-_]?/)
                
                if (folderNameMatch && folderNameMatch[1] === projectNum) {
                    results.push({
                        projectNumber: projectNum,
                        fullPath,
                        folderName: entry.name,
                        parentFolder: path.basename(currentDir)
                    })
                }
                
                // Recursively search subdirectories
                // Skip node_modules, .git, and other common non-project directories
                const skipDirs = ['node_modules', '.git', '.vscode', 'dist', 'build', 'tmp']
                if (!skipDirs.includes(entry.name)) {
                    await searchDirectory(fullPath)
                }
            }
        } catch (error) {
            console.error(`Error searching directory ${currentDir}:`, error)
        }
    }
    
    await searchDirectory(baseDir)
    return results
}

/**
 * Find a single project folder by project number (returns first match)
 * @param baseDir Base directory to search in
 * @param projectNumber Project number to search for
 * @returns First matching project folder or null
 */
export async function findProjectFolderSingle(
    baseDir: string,
    projectNumber: string | number
): Promise<ProjectFolderResult | null> {
    const results = await findProjectFolder(baseDir, projectNumber)
    return results.length > 0 ? results[0] : null
}

/**
 * Search for multiple project folders at once
 * @param baseDir Base directory to search in
 * @param projectNumbers Array of project numbers to search for
 * @returns Map of project numbers to their folder results
 */
export async function findProjectFolders(
    baseDir: string,
    projectNumbers: (string | number)[]
): Promise<Map<string, ProjectFolderResult[]>> {
    const resultMap = new Map<string, ProjectFolderResult[]>()
    
    // Initialize map with empty arrays
    for (const num of projectNumbers) {
        resultMap.set(num.toString(), [])
    }
    
    // Search for all project numbers in one pass
    async function searchDirectory(currentDir: string): Promise<void> {
        try {
            const entries = await readdir(currentDir, { withFileTypes: true })
            
            for (const entry of entries) {
                if (!entry.isDirectory()) continue
                
                const fullPath = path.join(currentDir, entry.name)
                
                // Check if folder name starts with any of the project numbers
                const folderNameMatch = entry.name.match(/^(\d+)[\s\-_]?/)
                
                if (folderNameMatch) {
                    const matchedNum = folderNameMatch[1]
                    if (resultMap.has(matchedNum)) {
                        const results = resultMap.get(matchedNum)!
                        results.push({
                            projectNumber: matchedNum,
                            fullPath,
                            folderName: entry.name,
                            parentFolder: path.basename(currentDir)
                        })
                    }
                }
                
                // Recursively search subdirectories
                const skipDirs = ['node_modules', '.git', '.vscode', 'dist', 'build', 'tmp']
                if (!skipDirs.includes(entry.name)) {
                    await searchDirectory(fullPath)
                }
            }
        } catch (error) {
            console.error(`Error searching directory ${currentDir}:`, error)
        }
    }
    
    if (existsSync(baseDir)) {
        await searchDirectory(baseDir)
    }
    
    return resultMap
}

/**
 * Get project folder path using a cache for better performance
 * Useful when repeatedly searching for the same projects
 */
export class ProjectFolderCache {
    private cache = new Map<string, ProjectFolderResult[]>()
    private baseDir: string
    private lastScan: Date | null = null
    private scanInterval = 60000 // 1 minute cache validity
    
    constructor(baseDir: string, scanInterval?: number) {
        this.baseDir = baseDir
        if (scanInterval) this.scanInterval = scanInterval
    }
    
    private shouldRefresh(): boolean {
        if (!this.lastScan) return true
        return Date.now() - this.lastScan.getTime() > this.scanInterval
    }
    
    async find(projectNumber: string | number): Promise<ProjectFolderResult | null> {
        const projectNum = projectNumber.toString()
        
        if (this.shouldRefresh() || !this.cache.has(projectNum)) {
            const results = await findProjectFolder(this.baseDir, projectNum)
            this.cache.set(projectNum, results)
            this.lastScan = new Date()
        }
        
        const cached = this.cache.get(projectNum)
        return cached && cached.length > 0 ? cached[0] : null
    }
    
    async findAll(projectNumber: string | number): Promise<ProjectFolderResult[]> {
        const projectNum = projectNumber.toString()
        
        if (this.shouldRefresh() || !this.cache.has(projectNum)) {
            const results = await findProjectFolder(this.baseDir, projectNum)
            this.cache.set(projectNum, results)
            this.lastScan = new Date()
        }
        
        return this.cache.get(projectNum) || []
    }
    
    clearCache(): void {
        this.cache.clear()
        this.lastScan = null
    }
}