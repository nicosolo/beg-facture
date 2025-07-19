PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_users` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`email` text NOT NULL,
	`lastName` text NOT NULL,
	`firstName` text NOT NULL,
	`initials` text NOT NULL,
	`archived` integer DEFAULT false NOT NULL,
	`password` text NOT NULL,
	`role` text NOT NULL,
	`activityRates` text DEFAULT '[]',
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP
);
--> statement-breakpoint
INSERT INTO `__new_users`("id", "email", "lastName", "firstName", "initials", "archived", "password", "role", "activityRates", "updatedAt", "createdAt") SELECT "id", "email", "lastName", "firstName", "initials", "archived", "password", "role", "activityRates", "updatedAt", "createdAt" FROM `users`;--> statement-breakpoint
DROP TABLE `users`;--> statement-breakpoint
ALTER TABLE `__new_users` RENAME TO `users`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_unique` ON `users` (`email`);--> statement-breakpoint
CREATE INDEX `users_email_idx` ON `users` (`email`);--> statement-breakpoint
CREATE INDEX `users_archived_idx` ON `users` (`archived`);--> statement-breakpoint
CREATE INDEX `users_role_idx` ON `users` (`role`);--> statement-breakpoint
CREATE INDEX `users_name_idx` ON `users` (`lastName`,`firstName`);--> statement-breakpoint
ALTER TABLE `projects` ADD `firstActivityDate` integer;--> statement-breakpoint
ALTER TABLE `projects` ADD `lastActivityDate` integer;--> statement-breakpoint
ALTER TABLE `projects` ADD `totalDuration` integer;--> statement-breakpoint
CREATE INDEX `projects_first_activity_date_idx` ON `projects` (`firstActivityDate`);--> statement-breakpoint
CREATE INDEX `projects_last_activity_date_idx` ON `projects` (`lastActivityDate`);--> statement-breakpoint
CREATE INDEX `projects_total_duration_idx` ON `projects` (`totalDuration`);