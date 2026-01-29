 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
import { useEffect, useMemo, useState } from 'react';

import { api } from '../services/api';

type Sector = {
  id: number;
  name: string;
  district: string;
  locality: string;
};

type Subactivity = {
  id: number;
  name: string;
};

type Point = {
  id: number;
  sector_id: number;
  subactivity_id: number;
  sgio?: string | null;
  direccion?: string | null;
  lat: number;
  lng: number;
};

type PointForm = {
  name: string;
  sectorId: string;
  subactivityId: string;
  lat: string;
  lng: string;
  radius: string;
};

const emptyForm: PointForm = {
  name: '',
  sectorId: '',
  subactivityId: '',
  lat: '',
  lng: '',
  radius: ''
};

export function PointsPage() {
  const [points, setPoints] = useState<Point[]>([]);
  const [sectors, setSectors] = useState<Sector[]>([]);
  const [subactivities, setSubactivities] = useState<Subactivity[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [form, setForm] = useState<PointForm>(emptyForm);
  const [saving, setSaving] = useState(false);
  const [importing, setImporting] = useState(false);
  const [importMessage, setImportMessage] = useState<string | null>(null);

  const sectorMap = useMemo(() => {
    return sectors.reduce<Record<number, Sector>>((acc, sector) => {
      acc[sector.id] = sector;
      return acc;
    }, {});
  }, [sectors]);

  const fetchPoints = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await api.get<Point[]>('/admin/points');
      setPoints(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al cargar puntos');
    } finally {
      setLoading(false);
    }
  };

  const fetchSectors = async () => {
    const response = await api.get<Sector[]>('/admin/sectors');
    setSectors(response.data);
  };

  const fetchSubactivities = async () => {
    const response = await api.get<Subactivity[]>('/admin/subactivities');
    setSubactivities(response.data);
  };

  useEffect(() => {
    fetchPoints();
    fetchSectors();
    fetchSubactivities();
  }, []);

  const openModal = () => {
    setForm(emptyForm);
    setFormError(null);
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  const handleChange = (field: keyof PointForm, value: string) => {
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    setFormError(null);
    setSaving(true);
    try {
      if (!form.sectorId || !form.subactivityId) {
        throw new Error('Selecciona sector y subactividad.');
      }
      await api.post('/admin/points', {
        sector_id: Number(form.sectorId),
        subactivity_id: Number(form.subactivityId),
        sgio: form.name,
        lat: Number(form.lat),
        lng: Number(form.lng)
      });
      closeModal();
      await fetchPoints();
    } catch (err) {
      setFormError(err instanceof Error ? err.message : 'Error al crear punto');
    } finally {
      setSaving(false);
    }
  };

  const handleImport = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;
    setImportMessage(null);
    setImporting(true);
    try {
      const formData = new FormData();
      formData.append('file', file);
      await api.post('/admin/points/import', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      setImportMessage('Importación completada.');
      await fetchPoints();
    } catch (err) {
      setImportMessage(err instanceof Error ? err.message : 'Error al importar CSV.');
    } finally {
      setImporting(false);
      event.target.value = '';
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h2 className="text-2xl font-semibold text-slate-800">Points</h2>
        <div className="flex items-center gap-2">
          <label className="rounded border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-50">
            {importing ? 'Importando...' : 'Import CSV'}
            <input
              type="file"
              accept=".csv"
              className="hidden"
              onChange={handleImport}
              disabled={importing}
            />
          </label>
          <button
            onClick={openModal}
            className="rounded bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700"
          >
            New Point
          </button>
        </div>
      </div>

      {importMessage && <p className="text-sm text-slate-600">{importMessage}</p>}
      {loading && <p className="text-sm text-slate-500">Cargando puntos...</p>}
      {error && <p className="text-sm text-red-600">{error}</p>}

      <div className="overflow-hidden rounded-lg bg-white shadow">
        <table className="min-w-full divide-y divide-slate-200 text-sm">
          <thead className="bg-slate-50 text-left text-slate-500">
            <tr>
              <th className="px-4 py-3 font-medium">Name</th>
              <th className="px-4 py-3 font-medium">Sector</th>
              <th className="px-4 py-3 font-medium">Latitude</th>
              <th className="px-4 py-3 font-medium">Longitude</th>
              <th className="px-4 py-3 font-medium">Radius (m)</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {points.map((point) => (
              <tr key={point.id} className="text-slate-700">
                <td className="px-4 py-3">{point.sgio || point.direccion || '—'}</td>
                <td className="px-4 py-3">{sectorMap[point.sector_id]?.name ?? '—'}</td>
                <td className="px-4 py-3">{point.lat.toFixed(6)}</td>
                <td className="px-4 py-3">{point.lng.toFixed(6)}</td>
                <td className="px-4 py-3">—</td>
              </tr>
            ))}
            {!loading && points.length === 0 && (
              <tr>
                <td colSpan={5} className="px-4 py-6 text-center text-slate-400">
                  No hay puntos registrados.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-md rounded-lg bg-white p-6 shadow-lg">
            <h3 className="text-lg font-semibold text-slate-800">Nuevo punto</h3>
            <form className="mt-4 space-y-4" onSubmit={handleSubmit}>
              <div>
                <label className="block text-sm font-medium text-slate-700">Name</label>
                <input
                  type="text"
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.name}
                  onChange={(event) => handleChange('name', event.target.value)}
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700">Sector</label>
                <select
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.sectorId}
                  onChange={(event) => handleChange('sectorId', event.target.value)}
                  required
                >
                  <option value="">Selecciona un sector</option>
                  {sectors.map((sector) => (
                    <option key={sector.id} value={sector.id}>
                      {sector.name} - {sector.district}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700">Subactivity</label>
                <select
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.subactivityId}
                  onChange={(event) => handleChange('subactivityId', event.target.value)}
                  required
                >
                  <option value="">Selecciona una subactividad</option>
                  {subactivities.map((subactivity) => (
                    <option key={subactivity.id} value={subactivity.id}>
                      {subactivity.name}
                    </option>
                  ))}
                </select>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700">Latitude</label>
                  <input
                    type="number"
                    step="any"
                    className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                    value={form.lat}
                    onChange={(event) => handleChange('lat', event.target.value)}
                    required
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700">Longitude</label>
                  <input
                    type="number"
                    step="any"
                    className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                    value={form.lng}
                    onChange={(event) => handleChange('lng', event.target.value)}
                    required
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700">Radius (m)</label>
                <input
                  type="number"
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.radius}
                  onChange={(event) => handleChange('radius', event.target.value)}
                  placeholder="Opcional"
                />
              </div>
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
=======
import { PlaceholderPage } from './PlaceholderPage';

export function PointsPage() {
  return (
    <PlaceholderPage
      title="Points"
      description="Gestión de puntos (pendiente de implementación)."
    />
 main
  );
}
