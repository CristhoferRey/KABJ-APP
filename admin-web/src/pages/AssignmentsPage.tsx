import { useEffect, useMemo, useState } from 'react';

import { api } from '../services/api';

type Assignment = {
  id: number;
  subactivity_id: number;
  sector_id: number;
  capataz_id: number;
  is_active: boolean;
};

type Point = {
  id: number;
  sector_id: number;
  subactivity_id: number;
  sgio?: string | null;
  direccion?: string | null;
};

type Sector = {
  id: number;
  name: string;
  district: string;
  locality: string;
};

type AssignmentForm = {
  capatazId: string;
  pointId: string;
  active: boolean;
};

const emptyForm: AssignmentForm = {
  capatazId: '',
  pointId: '',
  active: true
};

export function AssignmentsPage() {
  const [assignments, setAssignments] = useState<Assignment[]>([]);
  const [points, setPoints] = useState<Point[]>([]);
  const [sectors, setSectors] = useState<Sector[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [form, setForm] = useState<AssignmentForm>(emptyForm);
  const [saving, setSaving] = useState(false);
  const [toggleError, setToggleError] = useState<string | null>(null);

  const sectorMap = useMemo(() => {
    return sectors.reduce<Record<number, Sector>>((acc, sector) => {
      acc[sector.id] = sector;
      return acc;
    }, {});
  }, [sectors]);

  const pointMap = useMemo(() => {
    return points.reduce<Record<number, Point>>((acc, point) => {
      acc[point.id] = point;
      return acc;
    }, {});
  }, [points]);

  const capatazOptions = useMemo(() => {
    const ids = new Set(assignments.map((assignment) => assignment.capataz_id));
    return Array.from(ids).sort((a, b) => a - b);
  }, [assignments]);

  const fetchAssignments = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await api.get<Assignment[]>('/admin/assignments');
      setAssignments(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al cargar asignaciones');
    } finally {
      setLoading(false);
    }
  };

  const fetchPoints = async () => {
    const response = await api.get<Point[]>('/admin/points');
    setPoints(response.data);
  };

  const fetchSectors = async () => {
    const response = await api.get<Sector[]>('/admin/sectors');
    setSectors(response.data);
  };

  useEffect(() => {
    fetchAssignments();
    fetchPoints();
    fetchSectors();
  }, []);

  const openModal = () => {
    setForm(emptyForm);
    setFormError(null);
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  const handleChange = (field: keyof AssignmentForm, value: string | boolean) => {
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    setFormError(null);
    setSaving(true);
    try {
      if (!form.capatazId || !form.pointId) {
        throw new Error('Selecciona capataz y punto.');
      }
      const point = pointMap[Number(form.pointId)];
      if (!point) {
        throw new Error('Punto inválido.');
      }
      const today = new Date().toISOString().slice(0, 10);
      const response = await api.post<Assignment>('/admin/assignments', {
        capataz_id: Number(form.capatazId),
        subactivity_id: point.subactivity_id,
        sector_id: point.sector_id,
        date_from: today,
        date_to: today
      });
      if (!form.active) {
        await api.delete(`/admin/assignments/${response.data.id}`);
      }
      closeModal();
      await fetchAssignments();
    } catch (err) {
      setFormError(err instanceof Error ? err.message : 'Error al crear asignación');
    } finally {
      setSaving(false);
    }
  };

  const handleToggleActive = async (assignment: Assignment) => {
    setToggleError(null);
    if (assignment.is_active) {
      try {
        await api.delete(`/admin/assignments/${assignment.id}`);
        await fetchAssignments();
      } catch (err) {
        setToggleError(err instanceof Error ? err.message : 'Error al desactivar asignación');
      }
    } else {
      setToggleError('Reactivación no soportada actualmente.');
    }
  };

  const resolvePointName = (assignment: Assignment) => {
    const candidate = points.find(
      (point) =>
        point.sector_id === assignment.sector_id &&
        point.subactivity_id === assignment.subactivity_id
    );
    return candidate?.sgio || candidate?.direccion || '—';
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-semibold text-slate-800">Assignments</h2>
        <button
          onClick={openModal}
          className="rounded bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700"
        >
          New Assignment
        </button>
      </div>

      {loading && <p className="text-sm text-slate-500">Cargando asignaciones...</p>}
      {error && <p className="text-sm text-red-600">{error}</p>}
      {toggleError && <p className="text-sm text-red-600">{toggleError}</p>}

      <div className="overflow-hidden rounded-lg bg-white shadow">
        <table className="min-w-full divide-y divide-slate-200 text-sm">
          <thead className="bg-slate-50 text-left text-slate-500">
            <tr>
              <th className="px-4 py-3 font-medium">Capataz</th>
              <th className="px-4 py-3 font-medium">Point</th>
              <th className="px-4 py-3 font-medium">Sector</th>
              <th className="px-4 py-3 font-medium">Active</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {assignments.map((assignment) => (
              <tr key={assignment.id} className="text-slate-700">
                <td className="px-4 py-3">Capataz #{assignment.capataz_id}</td>
                <td className="px-4 py-3">{resolvePointName(assignment)}</td>
                <td className="px-4 py-3">{sectorMap[assignment.sector_id]?.name ?? '—'}</td>
                <td className="px-4 py-3">
                  <button
                    type="button"
                    onClick={() => handleToggleActive(assignment)}
                    className={`rounded px-3 py-1 text-xs font-medium ${
                      assignment.is_active
                        ? 'bg-green-100 text-green-700'
                        : 'bg-slate-100 text-slate-500'
                    }`}
                  >
                    {assignment.is_active ? 'Activo' : 'Inactivo'}
                  </button>
                </td>
              </tr>
            ))}
            {!loading && assignments.length === 0 && (
              <tr>
                <td colSpan={4} className="px-4 py-6 text-center text-slate-400">
                  No hay asignaciones registradas.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-md rounded-lg bg-white p-6 shadow-lg">
            <h3 className="text-lg font-semibold text-slate-800">Nueva asignación</h3>
            <form className="mt-4 space-y-4" onSubmit={handleSubmit}>
              <div>
                <label className="block text-sm font-medium text-slate-700">Capataz</label>
                <select
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.capatazId}
                  onChange={(event) => handleChange('capatazId', event.target.value)}
                  required
                >
                  <option value="">Selecciona capataz</option>
                  {capatazOptions.map((id) => (
                    <option key={id} value={id}>
                      Capataz #{id}
                    </option>
                  ))}
                </select>
                {capatazOptions.length === 0 && (
                  <p className="mt-1 text-xs text-slate-400">
                    No hay capataces disponibles. Agrega al menos uno en el backend.
                  </p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700">Point</label>
                <select
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.pointId}
                  onChange={(event) => handleChange('pointId', event.target.value)}
                  required
                >
                  <option value="">Selecciona un punto</option>
                  {points.map((point) => (
                    <option key={point.id} value={point.id}>
                      {point.sgio || point.direccion || `Punto ${point.id}`}
                    </option>
                  ))}
                </select>
              </div>
              <label className="flex items-center gap-2 text-sm text-slate-700">
                <input
                  type="checkbox"
                  checked={form.active}
                  onChange={(event) => handleChange('active', event.target.checked)}
                />
                Activo
              </label>
              {formError && <p className="text-sm text-red-600">{formError}</p>}
              <div className="flex justify-end gap-3">
                <button
                  type="button"
                  onClick={closeModal}
                  className="rounded border border-slate-300 px-4 py-2 text-sm text-slate-600"
                  disabled={saving}
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="rounded bg-slate-900 px-4 py-2 text-sm text-white hover:bg-slate-700 disabled:opacity-50"
                  disabled={saving}
                >
                  {saving ? 'Guardando...' : 'Crear'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
