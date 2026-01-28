import { useState } from 'react';

import { api } from '../services/api';

export function ExportPage() {
  const [date, setDate] = useState('');
  const [message, setMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleExport = async () => {
    setMessage(null);
    if (!date) {
      setMessage('Selecciona una fecha.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.post(`/admin/export?date=${date}`, null, {
        responseType: 'blob',
      });
      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = url;
      link.download = `exports_${date}.zip`;
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);
      setMessage('Export generado correctamente.');
    } catch (err) {
      setMessage(err instanceof Error ? err.message : 'Error al exportar.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold text-slate-800">Export</h2>
      <div className="rounded-lg bg-white p-6 shadow">
        <label className="block text-sm font-medium text-slate-700">Fecha</label>
        <input
          type="date"
          className="mt-1 w-full max-w-xs rounded border border-slate-300 px-3 py-2"
          value={date}
          onChange={(event) => setDate(event.target.value)}
        />
        {message && <p className="mt-2 text-sm text-slate-600">{message}</p>}
        <button
          type="button"
          onClick={handleExport}
          className="mt-4 rounded bg-slate-900 px-4 py-2 text-white hover:bg-slate-700 disabled:opacity-50"
          disabled={loading}
        >
          {loading ? 'Generando...' : 'Generar ZIP'}
        </button>
      </div>
    </div>
  );
}
