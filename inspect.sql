\pset pager off

SELECT 'Видеозаписи' AS category, count(*) AS rows FROM dbo.record
UNION ALL SELECT 'Результаты', count(*) FROM dbo.result
UNION ALL SELECT 'Пациенты', count(*) FROM dbo.patient
UNION ALL SELECT 'Фотографии', count(*) FROM dbo.picture
UNION ALL SELECT 'Файлы', count(*) FROM cc_system.files;

SELECT min("RecordDate") AS earliest, max("RecordDate") AS latest
FROM dbo.record;

SELECT result."Id" AS result_id,
       result."Patient_Id" AS patient_id,
       record."Id" AS record_id,
       record."RecordDate" AS recorded_at,
       eye."Name" AS eye,
       files.file_name,
       'sample-500/files/' || files.file_name AS local_path,
       result."ArterialVelocity",
       result."VenousVelocity",
       result."Density",
       result."Spins"
FROM dbo.result AS result
JOIN dbo.record AS record ON record."Id" = result."Record_Id"
JOIN cc_system.files AS files ON files.id = record.filename
JOIN dbo.eye AS eye ON eye."Id" = result."Eye_Id"
ORDER BY result."Id"
LIMIT 10;
