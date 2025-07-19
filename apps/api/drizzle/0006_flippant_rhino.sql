PRAGMA foreign_keys=OFF;--> statement-breakpoint
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
	`totalDuration` integer DEFAULT 0,
	`unBilledDuration` integer DEFAULT 0,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`locationId`) REFERENCES `locations`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`clientId`) REFERENCES `clients`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`engineerId`) REFERENCES `engineers`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`companyId`) REFERENCES `companies`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`typeId`) REFERENCES `project_types`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`projectManagerId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_projects`("id", "projectNumber", "name", "startDate", "locationId", "clientId", "engineerId", "companyId", "typeId", "remark", "projectManagerId", "printFlag", "firstActivityDate", "lastActivityDate", "totalDuration", "unBilledDuration", "updatedAt", "createdAt") SELECT "id", "projectNumber", "name", "startDate", "locationId", "clientId", "engineerId", "companyId", "typeId", "remark", "projectManagerId", "printFlag", "firstActivityDate", "lastActivityDate", "totalDuration", "unBilledDuration", "updatedAt", "createdAt" FROM `projects`;--> statement-breakpoint
DROP TABLE `projects`;--> statement-breakpoint
ALTER TABLE `__new_projects` RENAME TO `projects`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
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
CREATE INDEX `projects_total_duration_idx` ON `projects` (`totalDuration`);