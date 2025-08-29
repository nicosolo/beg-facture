CREATE TABLE `workloads` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`userId` integer NOT NULL,
	`year` integer NOT NULL,
	`month` integer NOT NULL,
	`workload` integer NOT NULL,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `workloads_user_year_month_idx` ON `workloads` (`userId`,`year`,`month`);--> statement-breakpoint
CREATE INDEX `workloads_user_idx` ON `workloads` (`userId`);--> statement-breakpoint
CREATE INDEX `workloads_year_idx` ON `workloads` (`year`);