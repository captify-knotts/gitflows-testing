CREATE TABLE flyway_schema_history (
    installed_rank INT PRIMARY KEY,
    version VARCHAR(50),
    description VARCHAR(200),
    type VARCHAR(20),
    script VARCHAR(1000),
    checksum INTEGER,
    installed_by VARCHAR(100),
    installed_on TIMESTAMP DEFAULT NOW(),
    execution_time INTEGER NOT NULL,
    success BOOLEAN
);

INSERT INTO flyway_schema_history (
            installed_rank,
            version,
            description,
            type,
            script,
            checksum,
            installed_by,
            installed_on,
            execution_time,
            success
        ) VALUES (
            1,
            '01.0.000',
            'New versioning schem',
            'BASELINE',
            'New versioning schem',
            NULL,
            current_user,
            NOW(),
            0,
            TRUE
        );