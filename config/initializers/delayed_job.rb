Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.backend = :active_record
