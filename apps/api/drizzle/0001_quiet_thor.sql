CREATE TABLE `user_group_members` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`groupId` integer NOT NULL,
	`userId` integer NOT NULL,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP NOT NULL,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`groupId`) REFERENCES `user_groups`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `user_group_members_group_idx` ON `user_group_members` (`groupId`);--> statement-breakpoint
CREATE INDEX `user_group_members_user_idx` ON `user_group_members` (`userId`);--> statement-breakpoint
CREATE INDEX `user_group_members_unique` ON `user_group_members` (`groupId`,`userId`);--> statement-breakpoint
CREATE TABLE `user_groups` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`name` text NOT NULL,
	`updatedAt` integer DEFAULT CURRENT_TIMESTAMP NOT NULL,
	`createdAt` integer DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
CREATE INDEX `user_groups_name_idx` ON `user_groups` (`name`);