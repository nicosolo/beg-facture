CREATE INDEX `project_access_user_project_idx` ON `project_access` (`userId`,`projectId`);--> statement-breakpoint
CREATE INDEX `project_access_user_idx` ON `project_access` (`userId`);--> statement-breakpoint
CREATE INDEX `project_access_project_idx` ON `project_access` (`projectId`);--> statement-breakpoint
CREATE INDEX `project_access_level_idx` ON `project_access` (`accessLevel`);--> statement-breakpoint
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
CREATE INDEX `users_email_idx` ON `users` (`email`);--> statement-breakpoint
CREATE INDEX `users_archived_idx` ON `users` (`archived`);--> statement-breakpoint
CREATE INDEX `users_role_idx` ON `users` (`role`);--> statement-breakpoint
CREATE INDEX `users_name_idx` ON `users` (`lastName`,`firstName`);