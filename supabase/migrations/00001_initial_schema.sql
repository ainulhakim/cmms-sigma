-- CMMS SIGMA - Initial Schema Migration
-- Creates all tables, enums, functions, indexes, and RLS policies

-- ============================================================
-- EXTENSIONS
-- ============================================================
-- uuid-ossp not needed with gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- ENUMS
-- ============================================================
CREATE TYPE user_role AS ENUM ('admin', 'supervisor', 'technician', 'viewer');
CREATE TYPE machine_status AS ENUM ('active', 'inactive', 'under_maintenance', 'broken_down', 'retired');
CREATE TYPE interval_type AS ENUM ('DAY', 'WEEK', 'MONTH', 'OPERATING_HOUR', 'PRODUCTION_COUNT', 'MANUAL');
CREATE TYPE maintenance_type AS ENUM ('preventive', 'corrective', 'predictive', 'condition_based', 'emergency');
CREATE TYPE wo_status AS ENUM ('OPEN', 'ASSIGNED', 'IN_PROGRESS', 'PAUSED', 'COMPLETED', 'VERIFIED', 'CANCELLED');
CREATE TYPE wo_priority AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE transaction_type AS ENUM ('in', 'out', 'adjustment', 'return');
CREATE TYPE notification_type AS ENUM ('work_order_assigned', 'work_order_completed', 'maintenance_due', 'breakdown_report', 'system');

-- ============================================================
-- TABLE: profiles (extends Supabase auth.users)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email           TEXT,
  full_name       TEXT NOT NULL DEFAULT '',
  phone           TEXT DEFAULT '',
  avatar_url      TEXT DEFAULT '',
  role            user_role NOT NULL DEFAULT 'technician',
  employee_code   TEXT UNIQUE DEFAULT '',
  is_active       BOOLEAN NOT NULL DEFAULT true,
  fcm_token       TEXT DEFAULT '',
  preferences     JSONB DEFAULT '{}',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: machine_categories
-- ============================================================
CREATE TABLE IF NOT EXISTS public.machine_categories (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT NOT NULL,
  description     TEXT DEFAULT '',
  icon            TEXT DEFAULT '',
  color           TEXT DEFAULT '#2196F3',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: machines
-- ============================================================
CREATE TABLE IF NOT EXISTS public.machines (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  machine_code    TEXT NOT NULL UNIQUE,
  machine_name    TEXT NOT NULL,
  machine_no      TEXT DEFAULT '',
  category_id     UUID REFERENCES public.machine_categories(id) ON DELETE SET NULL,
  line            TEXT DEFAULT '',
  location        TEXT DEFAULT '',
  manufacturer    TEXT DEFAULT '',
  model           TEXT DEFAULT '',
  serial_number   TEXT DEFAULT '',
  installation_date DATE,
  status          machine_status NOT NULL DEFAULT 'active',
  photo_url       TEXT DEFAULT '',
  specifications  JSONB DEFAULT '{}',
  operating_hours INTEGER DEFAULT 0,
  production_count INTEGER DEFAULT 0,
  notes           TEXT DEFAULT '',
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: maintenance_plans
-- ============================================================
CREATE TABLE IF NOT EXISTS public.maintenance_plans (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  machine_id             UUID NOT NULL REFERENCES public.machines(id) ON DELETE CASCADE,
  maintenance_name       TEXT NOT NULL,
  maintenance_type       maintenance_type NOT NULL DEFAULT 'preventive',
  interval_type          interval_type NOT NULL DEFAULT 'DAY',
  interval_value         INTEGER NOT NULL DEFAULT 30,
  estimated_duration_minutes INTEGER DEFAULT 60,
  priority               wo_priority NOT NULL DEFAULT 'medium',
  sop_document_url       TEXT DEFAULT '',
  description            TEXT DEFAULT '',
  is_active              BOOLEAN NOT NULL DEFAULT true,
  last_generated_at      TIMESTAMPTZ,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: maintenance_checklists
-- ============================================================
CREATE TABLE IF NOT EXISTS public.maintenance_checklists (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  maintenance_plan_id UUID NOT NULL REFERENCES public.maintenance_plans(id) ON DELETE CASCADE,
  item_name         TEXT NOT NULL,
  item_type         TEXT NOT NULL DEFAULT 'check' CHECK (item_type IN ('check', 'measure', 'text', 'yes_no', 'pass_fail')),
  expected_value    TEXT DEFAULT '',
  min_value         DECIMAL,
  max_value         DECIMAL,
  unit              TEXT DEFAULT '',
  sort_order        INTEGER NOT NULL DEFAULT 0,
  is_required       BOOLEAN NOT NULL DEFAULT true,
  notes             TEXT DEFAULT '',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: maintenance_schedules
-- ============================================================
CREATE TABLE IF NOT EXISTS public.maintenance_schedules (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  maintenance_plan_id UUID NOT NULL REFERENCES public.maintenance_plans(id) ON DELETE CASCADE,
  machine_id        UUID NOT NULL REFERENCES public.machines(id) ON DELETE CASCADE,
  scheduled_date    DATE NOT NULL,
  scheduled_start_time TIME DEFAULT '08:00',
  status            TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'generated', 'skipped', 'completed')),
  generated_wo_id   UUID,
  notes             TEXT DEFAULT '',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: work_orders
-- ============================================================
CREATE TABLE IF NOT EXISTS public.work_orders (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  work_order_number TEXT NOT NULL UNIQUE,
  machine_id        UUID NOT NULL REFERENCES public.machines(id) ON DELETE CASCADE,
  maintenance_plan_id UUID REFERENCES public.maintenance_plans(id) ON DELETE SET NULL,
  assigned_user_id  UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  scheduled_date    DATE,
  started_at        TIMESTAMPTZ,
  completed_at      TIMESTAMPTZ,
  status            wo_status NOT NULL DEFAULT 'OPEN',
  priority          wo_priority NOT NULL DEFAULT 'medium',
  problem_description TEXT DEFAULT '',
  action_taken      TEXT DEFAULT '',
  root_cause        TEXT DEFAULT '',
  downtime_minutes  INTEGER DEFAULT 0,
  technician_notes  TEXT DEFAULT '',
  supervisor_notes  TEXT DEFAULT '',
  verified_by       UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  verified_at       TIMESTAMPTZ,
  is_sync_complete  BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: work_order_checklist_results
-- ============================================================
CREATE TABLE IF NOT EXISTS public.work_order_checklist_results (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  work_order_id     UUID NOT NULL REFERENCES public.work_orders(id) ON DELETE CASCADE,
  checklist_item_id UUID REFERENCES public.maintenance_checklists(id) ON DELETE SET NULL,
  item_name         TEXT NOT NULL,
  item_type         TEXT NOT NULL DEFAULT 'check',
  result_value      TEXT DEFAULT '',
  result_bool       BOOLEAN,
  result_decimal    DECIMAL,
  is_passed         BOOLEAN,
  notes             TEXT DEFAULT '',
  sort_order        INTEGER DEFAULT 0,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: work_order_photos
-- ============================================================
CREATE TABLE IF NOT EXISTS public.work_order_photos (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  work_order_id   UUID NOT NULL REFERENCES public.work_orders(id) ON DELETE CASCADE,
  photo_url       TEXT NOT NULL,
  thumbnail_url   TEXT DEFAULT '',
  caption         TEXT DEFAULT '',
  photo_type      TEXT NOT NULL DEFAULT 'general' CHECK (photo_type IN ('general', 'before', 'after', 'problem', 'signature')),
  taken_by        UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  taken_at        TIMESTAMPTZ DEFAULT now(),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: breakdown_reports
-- ============================================================
CREATE TABLE IF NOT EXISTS public.breakdown_reports (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  machine_id        UUID NOT NULL REFERENCES public.machines(id) ON DELETE CASCADE,
  work_order_id     UUID REFERENCES public.work_orders(id) ON DELETE SET NULL,
  reported_by       UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  breakdown_time    TIMESTAMPTZ NOT NULL DEFAULT now(),
  downtime_start    TIMESTAMPTZ,
  downtime_end      TIMESTAMPTZ,
  total_downtime_minutes INTEGER DEFAULT 0,
  symptom           TEXT NOT NULL,
  root_cause        TEXT DEFAULT '',
  impact            TEXT DEFAULT '',
  action_taken      TEXT DEFAULT '',
  is_resolved       BOOLEAN NOT NULL DEFAULT false,
  resolved_at       TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: spare_parts
-- ============================================================
CREATE TABLE IF NOT EXISTS public.spare_parts (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  part_code         TEXT NOT NULL UNIQUE,
  part_name         TEXT NOT NULL,
  description       TEXT DEFAULT '',
  category          TEXT DEFAULT '',
  unit              TEXT NOT NULL DEFAULT 'pcs',
  current_stock     INTEGER NOT NULL DEFAULT 0,
  minimum_stock     INTEGER NOT NULL DEFAULT 0,
  maximum_stock     INTEGER DEFAULT 0,
  location          TEXT DEFAULT '',
  supplier          TEXT DEFAULT '',
  unit_price        DECIMAL(12,2) DEFAULT 0,
  photo_url         TEXT DEFAULT '',
  compatible_machines TEXT[] DEFAULT '{}',
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: spare_part_transactions
-- ============================================================
CREATE TABLE IF NOT EXISTS public.spare_part_transactions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  spare_part_id     UUID NOT NULL REFERENCES public.spare_parts(id) ON DELETE CASCADE,
  transaction_type  transaction_type NOT NULL,
  quantity          INTEGER NOT NULL,
  reference_type    TEXT DEFAULT '' CHECK (reference_type IN ('', 'work_order', 'purchase_order', 'adjustment', 'return')),
  reference_id      UUID,
  notes             TEXT DEFAULT '',
  performed_by      UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  transaction_date  TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: notifications
-- ============================================================
CREATE TABLE IF NOT EXISTS public.notifications (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  title             TEXT NOT NULL,
  body              TEXT DEFAULT '',
  notification_type notification_type NOT NULL DEFAULT 'system',
  reference_type    TEXT DEFAULT '',
  reference_id      UUID,
  is_read           BOOLEAN NOT NULL DEFAULT false,
  read_at           TIMESTAMPTZ,
  action_url        TEXT DEFAULT '',
  image_url         TEXT DEFAULT '',
  data              JSONB DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- TABLE: sync_queue (offline changes tracking)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.sync_queue (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name        TEXT NOT NULL,
  record_id         UUID NOT NULL,
  operation         TEXT NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
  payload           JSONB NOT NULL DEFAULT '{}',
  user_id           UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  device_id         TEXT DEFAULT '',
  status            TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'synced', 'failed')),
  error_message     TEXT DEFAULT '',
  synced_at         TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- FUNCTION: Auto-generate work_order_number
-- ============================================================
CREATE OR REPLACE FUNCTION generate_work_order_number()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
  year_part TEXT;
  month_part TEXT;
  seq_num INTEGER;
  result TEXT;
BEGIN
  year_part := to_char(now(), 'YY');
  month_part := to_char(now(), 'MM');

  -- Get next sequence number for this month (upsert pattern)
  INSERT INTO public.sequence_tracker (prefix, last_value)
  VALUES ('WO-' || year_part || month_part, 1)
  ON CONFLICT (prefix)
  DO UPDATE SET last_value = sequence_tracker.last_value + 1
  RETURNING last_value INTO seq_num;

  result := 'WO-' || year_part || month_part || '-' || LPAD(seq_num::TEXT, 5, '0');
  RETURN result;
END;
$$;

-- ============================================================
-- TABLE: sequence_tracker (for number generation)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.sequence_tracker (
  prefix      TEXT PRIMARY KEY,
  last_value  INTEGER NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- FUNCTION: Auto-set work_order_number on INSERT
-- ============================================================
CREATE OR REPLACE FUNCTION set_work_order_number()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.work_order_number IS NULL OR NEW.work_order_number = '' THEN
    NEW.work_order_number := generate_work_order_number();
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_set_work_order_number
  BEFORE INSERT ON public.work_orders
  FOR EACH ROW
  EXECUTE FUNCTION set_work_order_number();

-- ============================================================
-- FUNCTION: Auto-update updated_at columns
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- Apply updated_at trigger to all tables with updated_at column
CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_machines_updated_at
  BEFORE UPDATE ON public.machines FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_maintenance_plans_updated_at
  BEFORE UPDATE ON public.maintenance_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_work_orders_updated_at
  BEFORE UPDATE ON public.work_orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_breakdown_reports_updated_at
  BEFORE UPDATE ON public.breakdown_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_spare_parts_updated_at
  BEFORE UPDATE ON public.spare_parts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_machine_categories_updated_at
  BEFORE UPDATE ON public.machine_categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trg_maintenance_schedules_updated_at
  BEFORE UPDATE ON public.maintenance_schedules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- FUNCTION: Create profile on user signup
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', '')
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- INDEXES
-- ============================================================
-- Profiles
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_profiles_email ON public.profiles(email);
CREATE INDEX idx_profiles_is_active ON public.profiles(is_active);

-- Machines
CREATE INDEX idx_machines_status ON public.machines(status);
CREATE INDEX idx_machines_category_id ON public.machines(category_id);
CREATE INDEX idx_machines_location ON public.machines(location);
CREATE INDEX idx_machines_line ON public.machines(line);
CREATE INDEX idx_machines_machine_code ON public.machines(machine_code);

-- Maintenance Plans
CREATE INDEX idx_mp_machine_id ON public.maintenance_plans(machine_id);
CREATE INDEX idx_mp_interval_type ON public.maintenance_plans(interval_type);
CREATE INDEX idx_mp_is_active ON public.maintenance_plans(is_active);

-- Maintenance Checklists
CREATE INDEX idx_mc_plan_id ON public.maintenance_checklists(maintenance_plan_id);

-- Maintenance Schedules
CREATE INDEX idx_ms_plan_id ON public.maintenance_schedules(maintenance_plan_id);
CREATE INDEX idx_ms_machine_id ON public.maintenance_schedules(machine_id);
CREATE INDEX idx_ms_scheduled_date ON public.maintenance_schedules(scheduled_date);
CREATE INDEX idx_ms_status ON public.maintenance_schedules(status);

-- Work Orders
CREATE INDEX idx_wo_machine_id ON public.work_orders(machine_id);
CREATE INDEX idx_wo_assigned_user ON public.work_orders(assigned_user_id);
CREATE INDEX idx_wo_status ON public.work_orders(status);
CREATE INDEX idx_wo_priority ON public.work_orders(priority);
CREATE INDEX idx_wo_scheduled_date ON public.work_orders(scheduled_date);
CREATE INDEX idx_wo_created_at ON public.work_orders(created_at);
CREATE INDEX idx_wo_number ON public.work_orders(work_order_number);

-- Work Order Checklist Results
CREATE INDEX idx_wocr_work_order_id ON public.work_order_checklist_results(work_order_id);

-- Work Order Photos
CREATE INDEX idx_wop_work_order_id ON public.work_order_photos(work_order_id);

-- Breakdown Reports
CREATE INDEX idx_br_machine_id ON public.breakdown_reports(machine_id);
CREATE INDEX idx_br_is_resolved ON public.breakdown_reports(is_resolved);
CREATE INDEX idx_br_breakdown_time ON public.breakdown_reports(breakdown_time);

-- Spare Parts
CREATE INDEX idx_sp_part_code ON public.spare_parts(part_code);
CREATE INDEX idx_sp_is_active ON public.spare_parts(is_active);

-- Spare Part Transactions
CREATE INDEX idx_spt_part_id ON public.spare_part_transactions(spare_part_id);
CREATE INDEX idx_spt_type ON public.spare_part_transactions(transaction_type);
CREATE INDEX idx_spt_date ON public.spare_part_transactions(transaction_date);

-- Notifications
CREATE INDEX idx_notif_user_id ON public.notifications(user_id);
CREATE INDEX idx_notif_is_read ON public.notifications(is_read);
CREATE INDEX idx_notif_created_at ON public.notifications(created_at);

-- Sync Queue
CREATE INDEX idx_sync_status ON public.sync_queue(status);
CREATE INDEX idx_sync_created_at ON public.sync_queue(created_at);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.machine_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.machines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_checklists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.maintenance_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.work_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.work_order_checklist_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.work_order_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.breakdown_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.spare_parts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.spare_part_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sync_queue ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- RLS POLICIES - Helper: is_admin, is_supervisor, is_technician
-- ============================================================
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.is_supervisor()
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role IN ('admin', 'supervisor')
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.is_technician()
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role IN ('admin', 'supervisor', 'technician')
  );
END;
$$;

-- ============================================================
-- PROFILES POLICIES
-- ============================================================
-- Users can view their own profile
CREATE POLICY "Users view own profile"
  ON public.profiles FOR SELECT
  USING (id = auth.uid());

-- Admins can view all profiles
CREATE POLICY "Admins view all profiles"
  ON public.profiles FOR SELECT
  USING (public.is_admin());

-- Supervisors can view all profiles
CREATE POLICY "Supervisors view all profiles"
  ON public.profiles FOR SELECT
  USING (public.is_supervisor());

-- Users can update own profile
CREATE POLICY "Users update own profile"
  ON public.profiles FOR UPDATE
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- Admins can CRUD all profiles
CREATE POLICY "Admins manage all profiles"
  ON public.profiles FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- ============================================================
-- MACHINE CATEGORIES POLICIES
-- ============================================================
CREATE POLICY "Anyone can read machine categories"
  ON public.machine_categories FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Admins and supervisors manage categories"
  ON public.machine_categories FOR ALL
  USING (public.is_supervisor())
  WITH CHECK (public.is_supervisor());

-- ============================================================
-- MACHINES POLICIES
-- ============================================================
CREATE POLICY "Technicians can read machines"
  ON public.machines FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Viewers can read machines"
  ON public.machines FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Admins and supervisors manage machines"
  ON public.machines FOR INSERT
  WITH CHECK (public.is_supervisor());

CREATE POLICY "Admins and supervisors update machines"
  ON public.machines FOR UPDATE
  USING (public.is_supervisor())
  WITH CHECK (public.is_supervisor());

CREATE POLICY "Admins delete machines"
  ON public.machines FOR DELETE
  USING (public.is_admin());

-- ============================================================
-- MAINTENANCE PLANS POLICIES
-- ============================================================
CREATE POLICY "Technicians read maintenance plans"
  ON public.maintenance_plans FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Supervisors manage maintenance plans"
  ON public.maintenance_plans FOR ALL
  USING (public.is_supervisor())
  WITH CHECK (public.is_supervisor());

-- ============================================================
-- MAINTENANCE CHECKLISTS POLICIES
-- ============================================================
CREATE POLICY "Technicians read checklists"
  ON public.maintenance_checklists FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Supervisors manage checklists"
  ON public.maintenance_checklists FOR ALL
  USING (public.is_supervisor())
  WITH CHECK (public.is_supervisor());

-- ============================================================
-- MAINTENANCE SCHEDULES POLICIES
-- ============================================================
CREATE POLICY "Technicians read schedules"
  ON public.maintenance_schedules FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Supervisors manage schedules"
  ON public.maintenance_schedules FOR ALL
  USING (public.is_supervisor())
  WITH CHECK (public.is_supervisor());

-- ============================================================
-- WORK ORDERS POLICIES
-- ============================================================
CREATE POLICY "Technicians read assigned work orders"
  ON public.work_orders FOR SELECT
  USING (
    public.is_technician() AND (
      assigned_user_id = auth.uid() OR
      public.is_supervisor()
    )
  );

CREATE POLICY "Users create work orders"
  ON public.work_orders FOR INSERT
  WITH CHECK (public.is_technician());

CREATE POLICY "Technicians update own work orders"
  ON public.work_orders FOR UPDATE
  USING (
    (assigned_user_id = auth.uid() AND public.is_technician()) OR
    public.is_supervisor()
  )
  WITH CHECK (
    (assigned_user_id = auth.uid() AND public.is_technician()) OR
    public.is_supervisor()
  );

CREATE POLICY "Admins delete work orders"
  ON public.work_orders FOR DELETE
  USING (public.is_admin());

-- ============================================================
-- WORK ORDER CHECKLIST RESULTS POLICIES
-- ============================================================
CREATE POLICY "Technicians read checklist results"
  ON public.work_order_checklist_results FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Technicians insert checklist results"
  ON public.work_order_checklist_results FOR INSERT
  WITH CHECK (public.is_technician());

CREATE POLICY "Technicians update own checklist results"
  ON public.work_order_checklist_results FOR UPDATE
  USING (public.is_technician())
  WITH CHECK (public.is_technician());

-- ============================================================
-- WORK ORDER PHOTOS POLICIES
-- ============================================================
CREATE POLICY "Technicians read photos"
  ON public.work_order_photos FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Technicians insert photos"
  ON public.work_order_photos FOR INSERT
  WITH CHECK (public.is_technician());

CREATE POLICY "Technicians update own photos"
  ON public.work_order_photos FOR UPDATE
  USING (public.is_technician())
  WITH CHECK (public.is_technician());

-- ============================================================
-- BREAKDOWN REPORTS POLICIES
-- ============================================================
CREATE POLICY "Technicians read breakdowns"
  ON public.breakdown_reports FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Technicians report breakdowns"
  ON public.breakdown_reports FOR INSERT
  WITH CHECK (public.is_technician());

CREATE POLICY "Technicians update own breakdowns"
  ON public.breakdown_reports FOR UPDATE
  USING (
    (reported_by = auth.uid() AND public.is_technician()) OR
    public.is_supervisor()
  )
  WITH CHECK (
    (reported_by = auth.uid() AND public.is_technician()) OR
    public.is_supervisor()
  );

-- ============================================================
-- SPARE PARTS POLICIES
-- ============================================================
CREATE POLICY "Technicians read spare parts"
  ON public.spare_parts FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Supervisors manage spare parts"
  ON public.spare_parts FOR ALL
  USING (public.is_supervisor())
  WITH CHECK (public.is_supervisor());

-- ============================================================
-- SPARE PART TRANSACTIONS POLICIES
-- ============================================================
CREATE POLICY "Technicians read transactions"
  ON public.spare_part_transactions FOR SELECT
  USING (public.is_technician());

CREATE POLICY "Technicians insert transactions"
  ON public.spare_part_transactions FOR INSERT
  WITH CHECK (public.is_technician());

CREATE POLICY "Admins manage all transactions"
  ON public.spare_part_transactions FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- ============================================================
-- NOTIFICATIONS POLICIES
-- ============================================================
CREATE POLICY "Users read own notifications"
  ON public.notifications FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "System insert notifications for all"
  ON public.notifications FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users update own notifications"
  ON public.notifications FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users delete own notifications"
  ON public.notifications FOR DELETE
  USING (user_id = auth.uid());

-- ============================================================
-- SYNC QUEUE POLICIES
-- ============================================================
CREATE POLICY "Technicians read own sync entries"
  ON public.sync_queue FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Technicians insert sync entries"
  ON public.sync_queue FOR INSERT
  WITH CHECK (public.is_technician());

CREATE POLICY "System manage sync entries"
  ON public.sync_queue FOR UPDATE
  USING (public.is_supervisor())
  WITH CHECK (public.is_supervisor());

-- ============================================================
-- DEFAULT DATA
-- ============================================================
-- Insert default machine categories
INSERT INTO public.machine_categories (name, description, icon, color) VALUES
  ('Production Machine', 'Primary production equipment', 'precision_manufacturing', '#4CAF50'),
  ('Packaging Machine', 'Packaging and wrapping equipment', 'inventory_2', '#FF9800'),
  ('HVAC System', 'Heating, ventilation, and air conditioning', 'ac_unit', '#2196F3'),
  ('Electrical System', 'Electrical panels, generators, UPS', 'bolt', '#FFC107'),
  ('Conveyor System', 'Material handling conveyors', 'conveyor_belt', '#9C27B0'),
  ('Compressor', 'Air compressors and pneumatic systems', 'compression', '#00BCD4'),
  ('Pump', 'Water, chemical, and fluid pumps', 'water_pump', '#607D8B'),
  ('Vehicle', 'Forklifts, trucks, and mobile equipment', 'directions_car', '#795548')
ON CONFLICT DO NOTHING;

-- ============================================================
-- COMPOSITE INDEXES for common queries
-- ============================================================
CREATE INDEX idx_wo_assigned_status ON public.work_orders(assigned_user_id, status);
CREATE INDEX idx_wo_machine_status ON public.work_orders(machine_id, status);
CREATE INDEX idx_wo_created_status ON public.work_orders(created_at, status);
CREATE INDEX idx_br_machine_resolved ON public.breakdown_reports(machine_id, is_resolved);
CREATE INDEX idx_notif_user_read ON public.notifications(user_id, is_read, created_at DESC);
