ALTER TABLE IF EXISTS xandr_segment_mapping
ADD COLUMN IF NOT EXISTS upload_enabled boolean DEFAULT false NOT NULL;

ALTER TABLE IF EXISTS xandr_segment_mapping
ADD COLUMN IF NOT EXISTS member_id integer DEFAULT 1112 NOT NULL;

-- Drop the old constraint
ALTER TABLE public.xandr_segment_mapping
    DROP CONSTRAINT IF EXISTS captify_id_id_type_unique;

-- Add the new constraint with member_id
ALTER TABLE public.xandr_segment_mapping
    ADD CONSTRAINT captify_id_id_type_member_unique UNIQUE (captify_id, id_type, member_id);