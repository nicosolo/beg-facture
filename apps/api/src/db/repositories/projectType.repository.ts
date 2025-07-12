import { eq } from "drizzle-orm"
import { db } from "../index"
import { projectTypes } from "../schema"
import type {
    ProjectTypeSchema,
    ProjectTypeCreateInput,
    ProjectTypeUpdateInput,
} from "@beg/validations"

export const projectTypeRepository = {
    findAll: async (): Promise<ProjectTypeSchema[]> => {
        return await db
            .select({
                id: projectTypes.id,
                name: projectTypes.name,
                createdAt: projectTypes.createdAt,
                updatedAt: projectTypes.updatedAt,
            })
            .from(projectTypes)
    },

    findById: async (id: number) => {
        const results = await db
            .select({
                id: projectTypes.id,
                name: projectTypes.name,
                createdAt: projectTypes.createdAt,
                updatedAt: projectTypes.updatedAt,
            })
            .from(projectTypes)
            .where(eq(projectTypes.id, id))
        return results[0] || null
    },

    findByName: async (name: string) => {
        const results = await db
            .select({
                id: projectTypes.id,
                name: projectTypes.name,
                createdAt: projectTypes.createdAt,
                updatedAt: projectTypes.updatedAt,
            })
            .from(projectTypes)
            .where(eq(projectTypes.name, name))
        return results[0] || null
    },

    create: async (projectTypeData: ProjectTypeCreateInput): Promise<ProjectTypeSchema> => {
        const [newProjectType] = await db
            .insert(projectTypes)
            .values({
                name: projectTypeData.name,
                createdAt: new Date(),
                updatedAt: new Date(),
            })
            .returning({
                id: projectTypes.id,
                name: projectTypes.name,
                createdAt: projectTypes.createdAt,
                updatedAt: projectTypes.updatedAt,
            })

        return newProjectType
    },

    update: async (
        id: number,
        projectTypeData: Partial<ProjectTypeUpdateInput>
    ): Promise<ProjectTypeSchema> => {
        const updateData: any = {}

        if (projectTypeData.name) updateData.name = projectTypeData.name

        const [updatedProjectType] = await db
            .update(projectTypes)
            .set(updateData)
            .where(eq(projectTypes.id, id))
            .returning({
                id: projectTypes.id,
                name: projectTypes.name,
                createdAt: projectTypes.createdAt,
                updatedAt: projectTypes.updatedAt,
            })

        return updatedProjectType
    },

    delete: async (id: number): Promise<void> => {
        await db.delete(projectTypes).where(eq(projectTypes.id, id))
    },
}
