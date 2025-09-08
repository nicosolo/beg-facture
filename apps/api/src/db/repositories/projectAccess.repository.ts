import { db } from "@src/db"
import { projectAccess, users, projects } from "../schema"
import type { ProjectAccessLevel } from "@beg/validations"
import { eq, and, sql } from "drizzle-orm"

export interface ProjectAccessCreate {
    projectId: number
    userId: number
    accessLevel: ProjectAccessLevel
}

export interface ProjectAccessUpdate {
    accessLevel: ProjectAccessLevel
}

export class ProjectAccessRepository {
    async findById(id: number) {
        const result = await db
            .select({
                id: projectAccess.id,
                projectId: projectAccess.projectId,
                userId: projectAccess.userId,
                accessLevel: projectAccess.accessLevel,
                createdAt: projectAccess.createdAt,
                updatedAt: projectAccess.updatedAt,
                user: {
                    id: users.id,
                    name: sql`${users.firstName} || ' ' || ${users.lastName}`.as('name'),
                    email: users.email,
                    role: users.role,
                },
                project: {
                    id: projects.id,
                    name: projects.name,
                    projectNumber: projects.projectNumber,
                },
            })
            .from(projectAccess)
            .leftJoin(users, eq(projectAccess.userId, users.id))
            .leftJoin(projects, eq(projectAccess.projectId, projects.id))
            .where(eq(projectAccess.id, id))
            .limit(1)

        return result[0] || null
    }

    async findByProjectId(projectId: number) {
        return await db
            .select({
                id: projectAccess.id,
                projectId: projectAccess.projectId,
                userId: projectAccess.userId,
                accessLevel: projectAccess.accessLevel,
                createdAt: projectAccess.createdAt,
                updatedAt: projectAccess.updatedAt,
                user: {
                    id: users.id,
                    name: sql`${users.firstName} || ' ' || ${users.lastName}`.as('name'),
                    email: users.email,
                    role: users.role,
                },
            })
            .from(projectAccess)
            .leftJoin(users, eq(projectAccess.userId, users.id))
            .where(eq(projectAccess.projectId, projectId))
            .orderBy(users.firstName)
    }

    async findByUserId(userId: number) {
        return await db
            .select({
                id: projectAccess.id,
                projectId: projectAccess.projectId,
                userId: projectAccess.userId,
                accessLevel: projectAccess.accessLevel,
                createdAt: projectAccess.createdAt,
                updatedAt: projectAccess.updatedAt,
                project: {
                    id: projects.id,
                    name: projects.name,
                    projectNumber: projects.projectNumber,
                },
            })
            .from(projectAccess)
            .leftJoin(projects, eq(projectAccess.projectId, projects.id))
            .where(eq(projectAccess.userId, userId))
            .orderBy(projects.name)
    }

    async findByUserAndProject(userId: number, projectId: number) {
        const result = await db
            .select()
            .from(projectAccess)
            .where(and(eq(projectAccess.userId, userId), eq(projectAccess.projectId, projectId)))
            .limit(1)

        return result[0] || null
    }

    async create(data: ProjectAccessCreate) {
        const result = await db
            .insert(projectAccess)
            .values({
                ...data,
                createdAt: sql`CURRENT_TIMESTAMP`,
                updatedAt: sql`CURRENT_TIMESTAMP`,
            })
            .returning()

        return result[0]
    }

    async update(id: number, data: ProjectAccessUpdate) {
        const result = await db
            .update(projectAccess)
            .set({
                ...data,
                updatedAt: sql`CURRENT_TIMESTAMP`,
            })
            .where(eq(projectAccess.id, id))
            .returning()

        return result[0] || null
    }

    async delete(id: number) {
        const result = await db.delete(projectAccess).where(eq(projectAccess.id, id)).returning()

        return result[0] || null
    }

    async deleteByUserAndProject(userId: number, projectId: number) {
        const result = await db
            .delete(projectAccess)
            .where(and(eq(projectAccess.userId, userId), eq(projectAccess.projectId, projectId)))
            .returning()

        return result[0] || null
    }

    async upsert(data: ProjectAccessCreate) {
        const existing = await this.findByUserAndProject(data.userId, data.projectId)

        if (existing) {
            return await this.update(existing.id, { accessLevel: data.accessLevel })
        }

        return await this.create(data)
    }
}

export const projectAccessRepository = new ProjectAccessRepository()