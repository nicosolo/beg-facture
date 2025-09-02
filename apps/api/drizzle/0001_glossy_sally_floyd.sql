PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_activities` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer NOT NULL,
	`date` integer NOT NULL,
	`duration` integer NOT NULL,
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
CREATE INDEX `activities_invoice_idx` ON `activities` (`invoiceId`);