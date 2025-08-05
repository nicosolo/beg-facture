CREATE TABLE `invoice_adjudications` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`invoiceId` integer NOT NULL,
	`file` text DEFAULT '' NOT NULL,
	`date` integer NOT NULL,
	`amount` integer DEFAULT 0 NOT NULL,
	`remark` text DEFAULT '',
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`invoiceId`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `invoice_adjudications_invoice_idx` ON `invoice_adjudications` (`invoiceId`);--> statement-breakpoint
CREATE TABLE `invoice_offers` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`invoiceId` integer NOT NULL,
	`file` text DEFAULT '' NOT NULL,
	`date` integer NOT NULL,
	`amount` integer DEFAULT 0 NOT NULL,
	`remark` text DEFAULT '',
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`invoiceId`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `invoice_offers_invoice_idx` ON `invoice_offers` (`invoiceId`);--> statement-breakpoint
CREATE TABLE `invoice_rates` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`invoiceId` integer NOT NULL,
	`rateClass` text NOT NULL,
	`baseMinutes` integer DEFAULT 0 NOT NULL,
	`adjustedMinutes` integer DEFAULT 0 NOT NULL,
	`hourlyRate` integer DEFAULT 0 NOT NULL,
	`amount` integer DEFAULT 0 NOT NULL,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`invoiceId`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `invoice_rates_invoice_idx` ON `invoice_rates` (`invoiceId`);--> statement-breakpoint
CREATE TABLE `invoices` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`projectId` integer NOT NULL,
	`invoiceNumber` text NOT NULL,
	`reference` text NOT NULL,
	`type` text DEFAULT 'Facture' NOT NULL,
	`billingMode` text DEFAULT 'accordingToData' NOT NULL,
	`status` text DEFAULT 'draft' NOT NULL,
	`issueDate` integer NOT NULL,
	`dueDate` integer,
	`periodStart` integer NOT NULL,
	`periodEnd` integer NOT NULL,
	`clientId` integer NOT NULL,
	`recipientName` text NOT NULL,
	`recipientAddress` text NOT NULL,
	`description` text NOT NULL,
	`feesBase` integer DEFAULT 0 NOT NULL,
	`feesAdjusted` integer DEFAULT 0 NOT NULL,
	`feesTotal` integer DEFAULT 0 NOT NULL,
	`feesOthers` integer DEFAULT 0 NOT NULL,
	`feesFinalTotal` integer DEFAULT 0 NOT NULL,
	`feesMultiplicationFactor` integer DEFAULT 100 NOT NULL,
	`feesDiscountPercentage` integer,
	`feesDiscountAmount` integer,
	`expensesTravelBase` integer DEFAULT 0 NOT NULL,
	`expensesTravelAdjusted` integer DEFAULT 0 NOT NULL,
	`expensesTravelRate` integer DEFAULT 65 NOT NULL,
	`expensesTravelAmount` integer DEFAULT 0 NOT NULL,
	`expensesOtherBase` integer DEFAULT 0 NOT NULL,
	`expensesOtherAmount` integer DEFAULT 0 NOT NULL,
	`expensesTotal` integer DEFAULT 0 NOT NULL,
	`expensesThirdPartyAmount` integer DEFAULT 0 NOT NULL,
	`expensesPackagePercentage` integer,
	`expensesPackageAmount` integer,
	`expensesTotalExpenses` integer DEFAULT 0 NOT NULL,
	`totalHT` integer DEFAULT 0 NOT NULL,
	`vatRate` integer DEFAULT 800 NOT NULL,
	`vatAmount` integer DEFAULT 0 NOT NULL,
	`totalTTC` integer DEFAULT 0 NOT NULL,
	`otherServices` text DEFAULT '',
	`remarksOtherServices` text DEFAULT '',
	`remarksTravelExpenses` text DEFAULT '',
	`remarksExpenses` text DEFAULT '',
	`remarksThirdPartyExpenses` text DEFAULT '',
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`projectId`) REFERENCES `projects`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`clientId`) REFERENCES `clients`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `invoices_invoiceNumber_unique` ON `invoices` (`invoiceNumber`);--> statement-breakpoint
CREATE INDEX `invoices_invoice_number_idx` ON `invoices` (`invoiceNumber`);--> statement-breakpoint
CREATE INDEX `invoices_project_idx` ON `invoices` (`projectId`);--> statement-breakpoint
CREATE INDEX `invoices_client_idx` ON `invoices` (`clientId`);--> statement-breakpoint
CREATE INDEX `invoices_status_idx` ON `invoices` (`status`);--> statement-breakpoint
CREATE INDEX `invoices_issue_date_idx` ON `invoices` (`issueDate`);--> statement-breakpoint
CREATE INDEX `invoices_project_status_idx` ON `invoices` (`projectId`,`status`);--> statement-breakpoint
PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_activities` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer NOT NULL,
	`date` integer NOT NULL,
	`duration` integer NOT NULL,
	`kilometers` integer NOT NULL,
	`expenses` integer NOT NULL,
	`rate` integer NOT NULL,
	`projectId` integer NOT NULL,
	`activityTypeId` integer NOT NULL,
	`description` text,
	`billed` integer DEFAULT false NOT NULL,
	`invoiceId` integer,
	`disbursement` integer DEFAULT false NOT NULL,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`projectId`) REFERENCES `projects`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`activityTypeId`) REFERENCES `activity_types`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`invoiceId`) REFERENCES `invoices`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_activities`("id", "userId", "date", "duration", "kilometers", "expenses", "rate", "projectId", "activityTypeId", "description", "billed", "invoiceId", "disbursement", "updatedAt", "createdAt") SELECT "id", "userId", "date", "duration", "kilometers", "expenses", "rate", "projectId", "activityTypeId", "description", "billed", "invoiceId", "disbursement", "updatedAt", "createdAt" FROM `activities`;--> statement-breakpoint
DROP TABLE `activities`;--> statement-breakpoint
ALTER TABLE `__new_activities` RENAME TO `activities`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
CREATE INDEX `activities_user_project_idx` ON `activities` (`userId`,`projectId`);--> statement-breakpoint
CREATE INDEX `activities_date_idx` ON `activities` (`date`);--> statement-breakpoint
CREATE INDEX `activities_billed_idx` ON `activities` (`billed`);--> statement-breakpoint
CREATE INDEX `activities_project_billed_idx` ON `activities` (`projectId`,`billed`);--> statement-breakpoint
CREATE INDEX `activities_invoice_idx` ON `activities` (`invoiceId`);