ALTER TABLE `projects` ADD `ended` integer DEFAULT false;--> statement-breakpoint
ALTER TABLE `projects` ADD `archived` integer DEFAULT false;--> statement-breakpoint
CREATE INDEX `projects_archived_idx` ON `projects` (`archived`);--> statement-breakpoint
CREATE INDEX `projects_ended_idx` ON `projects` (`ended`);