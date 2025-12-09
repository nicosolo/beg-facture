DROP TABLE `user_group_members`;--> statement-breakpoint
ALTER TABLE `users` ADD `groupId` integer;--> statement-breakpoint
CREATE INDEX `users_group_idx` ON `users` (`groupId`);