import { useEffect, useState } from 'react';

import { api } from '../services/api';

type Sector = {
  id: number;
  name: string;
  district: string;
  locality: string;
};

type SectorForm = {
  name: string;
  district: string;
  locality: string;
};

const emptyForm: SectorForm = {
  name: '',
  district: '',
  locality: ''
};

export function SectorsPage() {
  const [sectors, setSectors] = useState<Sector[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [form, setForm] = useState<SectorForm>(emptyForm);
  const [saving, setSaving] = useState(false);

  const fetchSectors = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await api.get<Sector[]>('/admin/sectors');
      setSectors(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al cargar sectores');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
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

  const handleChange = (field: keyof SectorForm, value: string) => {
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    setFormError(null);
    setSaving(true);
    try {
      await api.post('/admin/sectors', form);
      closeModal();
      await fetchSectors();
    } catch (err) {
      setFormError(err instanceof Error ? err.message : 'Error al crear sector');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-semibold text-slate-800">Sectors</h2>
        <button
          onClick={openModal}
          className="rounded bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700"
        >
          New Sector
        </button>
      </div>

      {loading && <p className="text-sm text-slate-500">Cargando sectores...</p>}
      {error && <p className="text-sm text-red-600">{error}</p>}

      <div className="overflow-hidden rounded-lg bg-white shadow">
        <table className="min-w-full divide-y divide-slate-200 text-sm">
          <thead className="bg-slate-50 text-left text-slate-500">
            <tr>
              <th className="px-4 py-3 font-medium">Name</th>
              <th className="px-4 py-3 font-medium">District</th>
              <th className="px-4 py-3 font-medium">Locality</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {sectors.map((sector) => (
              <tr key={sector.id} className="text-slate-700">
                <td className="px-4 py-3">{sector.name}</td>
                <td className="px-4 py-3">{sector.district}</td>
                <td className="px-4 py-3">{sector.locality}</td>
              </tr>
            ))}
            {!loading && sectors.length === 0 && (
              <tr>
                <td colSpan={3} className="px-4 py-6 text-center text-slate-400">
                  No hay sectores registrados.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-md rounded-lg bg-white p-6 shadow-lg">
            <h3 className="text-lg font-semibold text-slate-800">Nuevo sector</h3>
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
                <label className="block text-sm font-medium text-slate-700">District</label>
                <input
                  type="text"
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.district}
                  onChange={(event) => handleChange('district', event.target.value)}
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700">Locality</label>
                <input
                  type="text"
                  className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
                  value={form.locality}
                  onChange={(event) => handleChange('locality', event.target.value)}
                  required
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
  );
}
