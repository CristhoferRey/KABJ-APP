import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

import { api } from '../services/api';
import { authService } from '../services/auth';

export function LoginPage() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    setError(null);
    setLoading(true);
    try {
      const response = await api.post('/auth/login', { email, password });
      const token = response.data?.access_token as string | undefined;
      if (!token) {
        throw new Error('Token inválido');
      }
      const role = authService.getRole(token);
      if (role !== 'ADMIN') {
        throw new Error('Acceso denegado: usuario no es ADMIN');
      }
      authService.setToken(token);
      navigate('/dashboard');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al iniciar sesión');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-100 p-6">
      <div className="w-full max-w-md rounded-lg bg-white p-8 shadow">
        <h2 className="text-2xl font-semibold text-slate-800">Login ADMIN</h2>
        <p className="mt-2 text-sm text-slate-500">Ingresa con tu cuenta administrativa.</p>

        <form className="mt-6 space-y-4" onSubmit={handleSubmit}>
          <div>
            <label className="block text-sm font-medium text-slate-700">Email</label>
            <input
              type="email"
              className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-slate-700">Password</label>
            <input
              type="password"
              className="mt-1 w-full rounded border border-slate-300 px-3 py-2"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              required
            />
          </div>
          {error && <p className="text-sm text-red-600">{error}</p>}
          <button
            type="submit"
            className="w-full rounded bg-slate-900 px-4 py-2 text-white hover:bg-slate-700 disabled:opacity-50"
            disabled={loading}
          >
            {loading ? 'Ingresando...' : 'Ingresar'}
          </button>
        </form>
      </div>
    </div>
  );
}
