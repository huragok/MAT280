-- For the setup of the PostgreSQL database and the creation of the rest of the tables, see the related course project "STA208" which is based on the same dataset.

CREATE TABLE pickup_count_by_hour_ct AS
SELECT pickup_gid, EXTRACT(hour FROM pickup_datetime) AS pickup_hour, COUNT(*) / 365.0 AS count_mean_pickup
FROM trip, trip_ct
WHERE trip_ct.trip_id=trip.trip_id
GROUP BY pickup_gid, pickup_hour
ORDER BY pickup_gid, pickup_hour; 

CREATE TABLE dropoff_count_by_hour_ct AS
SELECT dropoff_gid, EXTRACT(hour FROM dropoff_datetime) AS dropoff_hour, COUNT(*) / 365.0 AS count_mean_dropoff
FROM trip, trip_ct
WHERE trip_ct.trip_id=trip.trip_id
GROUP BY dropoff_gid, dropoff_hour
ORDER BY dropoff_gid, dropoff_hour; 

CREATE TABLE count_by_hour_ct AS
SELECT *
FROM pickup_count_by_hour_ct
FULL OUTER JOIN dropoff_count_by_hour_ct
ON pickup_gid=dropoff_gid AND pickup_hour=dropoff_hour;

-- 
CREATE TABLE pickup_count_by_hour_ct_green AS
SELECT pickup_gid, EXTRACT(hour FROM pickup_datetime) AS pickup_hour, COUNT(*) / 365.0 AS count_mean_pickup
FROM trip, trip_ct
WHERE trip_ct.trip_id=trip.trip_id AND NOT is_yellow
GROUP BY pickup_gid, pickup_hour
ORDER BY pickup_gid, pickup_hour; 

CREATE TABLE dropoff_count_by_hour_ct_green AS
SELECT dropoff_gid, EXTRACT(hour FROM dropoff_datetime) AS dropoff_hour, COUNT(*) / 365.0 AS count_mean_dropoff
FROM trip, trip_ct
WHERE trip_ct.trip_id=trip.trip_id AND NOT is_yellow
GROUP BY dropoff_gid, dropoff_hour
ORDER BY dropoff_gid, dropoff_hour; 

CREATE TABLE count_by_hour_ct_green AS
SELECT *
FROM pickup_count_by_hour_ct_green
FULL OUTER JOIN dropoff_count_by_hour_ct_green
ON pickup_gid=dropoff_gid AND pickup_hour=dropoff_hour;
