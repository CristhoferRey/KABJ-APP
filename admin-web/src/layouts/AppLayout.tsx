import { NavLink, Outlet } from 'react-router-dom';

import { authService } from '../services/auth';

const navItems = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/sectors', label: 'Sectors' },
  { to: '/points', label: 'Points' },
  { to: '/assignments', label: 'Assignments' },
  { to: '/export', label: 'Export' },
];

export function AppLayout() {
  const handleLogout = () => {
    authService.clearToken();
    window.location.href = '/login';
  };

  return (
    <div className="min-h-screen bg-slate-100">
      <header className="flex items-center justify-between border-b bg-white px-6 py-4 shadow-sm">
        <h1 className="text-xl font-semibold text-slate-800">KABJ Admin</h1>
        <button
          onClick={handleLogout}
          className="rounded bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700"
        >
          Logout
        </button>
      </header>
      <div className="flex">
        <aside className="w-56 border-r bg-white p-4">
          <nav className="space-y-2">
            {navItems.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `block rounded px-3 py-2 text-sm font-medium ${
                    isActive ? 'bg-slate-900 text-white' : 'text-slate-600 hover:bg-slate-100'
                  }`
                }
              >
                {item.label}
              </NavLink>
            ))}
          </nav>
        </aside>
        <main className="flex-1 p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
