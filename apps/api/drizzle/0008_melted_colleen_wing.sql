ALTER TABLE `projects` ADD `unBilledDisbursementDuration` integer DEFAULT 0;--> statement-breakpoint
CREATE INDEX `projects_un_billed_duration_idx` ON `projects` (`unBilledDuration`);--> statement-breakpoint
CREATE INDEX `projects_un_billed_disbursement_duration_idx` ON `projects` (`unBilledDisbursementDuration`);