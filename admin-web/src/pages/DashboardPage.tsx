import { useEffect, useState } from 'react';

import { StatCard } from '../components/StatCard';
import { api } from '../services/api';

type SummaryResponse = {
  executed_today: number;
  pending_today: number;
};

export function DashboardPage() {
  const [summary, setSummary] = useState<SummaryResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchSummary = async () => {
      setLoading(true);
      setError(null);
      try {
        // TODO: Replace with admin summary endpoint when available.
        const response = await api.get<SummaryResponse>('/mobile/summary');
        setSummary(response.data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'No se pudo cargar el resumen');
      } finally {
        setLoading(false);
      }
    };

    fetchSummary();
  }, []);

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold text-slate-800">Dashboard</h2>
      {loading && <p className="text-sm text-slate-500">Cargando resumen...</p>}
      {error && <p className="text-sm text-red-600">{error}</p>}
      <div className="grid gap-4 md:grid-cols-2">
        <StatCard label="Ejecutados hoy" value={summary?.executed_today ?? '-'} />
        <StatCard label="Pendientes hoy" value={summary?.pending_today ?? '-'} />
      </div>
    </div>
  );
}
