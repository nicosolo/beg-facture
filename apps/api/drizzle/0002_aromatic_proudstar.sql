PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_activities` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer NOT NULL,
	`date` integer NOT NULL,
	`duration` real NOT NULL,
	`kilometers` real NOT NULL,
	`expenses` real NOT NULL,
	`rate` real NOT NULL,
	`projectId` integer NOT NULL,
	`activityTypeId` integer NOT NULL,
	`description` text,
	`billed` integer DEFAULT false NOT NULL,
	`invoiceId` integer,
	`disbursement` integer DEFAULT false NOT NULL,
	`rateClass` text,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`projectId`) REFERENCES `projects`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`activityTypeId`) REFERENCES `activity_types`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`invoiceId`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
INSERT INTO `__new_activities`("id", "userId", "date", "duration", "kilometers", "expenses", "rate", "projectId", "activityTypeId", "description", "billed", "invoiceId", "disbursement", "rateClass", "updatedAt", "createdAt") SELECT "id", "userId", "date", "duration", "kilometers", "expenses", "rate", "projectId", "activityTypeId", "description", "billed", "invoiceId", "disbursement", "rateClass", "updatedAt", "createdAt" FROM `activities`;--> statement-breakpoint
DROP TABLE `activities`;--> statement-breakpoint
ALTER TABLE `__new_activities` RENAME TO `activities`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
CREATE INDEX `activities_user_project_idx` ON `activities` (`userId`,`projectId`);--> statement-breakpoint
CREATE INDEX `activities_date_idx` ON `activities` (`date`);--> statement-breakpoint
CREATE INDEX `activities_billed_idx` ON `activities` (`billed`);--> statement-breakpoint
CREATE INDEX `activities_project_billed_idx` ON `activities` (`projectId`,`billed`);--> statement-breakpoint
CREATE INDEX `activities_invoice_idx` ON `activities` (`invoiceId`);--> statement-breakpoint
CREATE TABLE `__new_projects` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`projectNumber` text NOT NULL,
	`name` text NOT NULL,
	`startDate` integer NOT NULL,
	`locationId` integer,
	`clientId` integer,
	`engineerId` integer,
	`companyId` integer,
	`typeId` integer NOT NULL,
	`remark` text,
	`projectManagerId` integer,
	`printFlag` integer DEFAULT false,
	`firstActivityDate` integer,
	`lastActivityDate` integer,
	`totalDuration` real DEFAULT 0,
	`unBilledDuration` real DEFAULT 0,
	`unBilledDisbursementDuration` real DEFAULT 0,
	`ended` integer DEFAULT false,
	`archived` integer DEFAULT false,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`locationId`) REFERENCES `locations`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`clientId`) REFERENCES `clients`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`engineerId`) REFERENCES `engineers`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`companyId`) REFERENCES `companies`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`typeId`) REFERENCES `project_types`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`projectManagerId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
INSERT INTO `__new_projects`("id", "projectNumber", "name", "startDate", "locationId", "clientId", "engineerId", "companyId", "typeId", "remark", "projectManagerId", "printFlag", "firstActivityDate", "lastActivityDate", "totalDuration", "unBilledDuration", "unBilledDisbursementDuration", "ended", "archived", "updatedAt", "createdAt") SELECT "id", "projectNumber", "name", "startDate", "locationId", "clientId", "engineerId", "companyId", "typeId", "remark", "projectManagerId", "printFlag", "firstActivityDate", "lastActivityDate", "totalDuration", "unBilledDuration", "unBilledDisbursementDuration", "ended", "archived", "updatedAt", "createdAt" FROM `projects`;--> statement-breakpoint
DROP TABLE `projects`;--> statement-breakpoint
ALTER TABLE `__new_projects` RENAME TO `projects`;--> statement-breakpoint
CREATE INDEX `projects_project_manager_idx` ON `projects` (`projectManagerId`);--> statement-breakpoint
CREATE INDEX `projects_name_idx` ON `projects` (`name`);--> statement-breakpoint
CREATE INDEX `projects_project_number_idx` ON `projects` (`projectNumber`);--> statement-breakpoint
CREATE INDEX `projects_start_date_idx` ON `projects` (`startDate`);--> statement-breakpoint
CREATE INDEX `projects_updated_at_idx` ON `projects` (`updatedAt`);--> statement-breakpoint
CREATE INDEX `projects_location_idx` ON `projects` (`locationId`);--> statement-breakpoint
CREATE INDEX `projects_client_idx` ON `projects` (`clientId`);--> statement-breakpoint
CREATE INDEX `projects_engineer_idx` ON `projects` (`engineerId`);--> statement-breakpoint
CREATE INDEX `projects_company_idx` ON `projects` (`companyId`);--> statement-breakpoint
CREATE INDEX `projects_type_idx` ON `projects` (`typeId`);--> statement-breakpoint
CREATE INDEX `projects_first_activity_date_idx` ON `projects` (`firstActivityDate`);--> statement-breakpoint
CREATE INDEX `projects_last_activity_date_idx` ON `projects` (`lastActivityDate`);--> statement-breakpoint
CREATE INDEX `projects_total_duration_idx` ON `projects` (`totalDuration`);--> statement-breakpoint
CREATE INDEX `projects_archived_idx` ON `projects` (`archived`);--> statement-breakpoint
CREATE INDEX `projects_ended_idx` ON `projects` (`ended`);--> statement-breakpoint
CREATE INDEX `projects_un_billed_duration_idx` ON `projects` (`unBilledDuration`);--> statement-breakpoint
CREATE INDEX `projects_un_billed_disbursement_duration_idx` ON `projects` (`unBilledDisbursementDuration`);