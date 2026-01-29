import { Navigate, Route, Routes } from 'react-router-dom';

import { AppLayout } from './layouts/AppLayout';
import { authService } from './services/auth';
import { AssignmentsPage } from './pages/AssignmentsPage';
import { DashboardPage } from './pages/DashboardPage';
import { ExportPage } from './pages/ExportPage';
import { LoginPage } from './pages/LoginPage';
import { PointsPage } from './pages/PointsPage';
import { SectorsPage } from './pages/SectorsPage';

const RequireAuth = ({ children }: { children: JSX.Element }) => {
  const token = authService.getToken();
  if (!token) {
    return <Navigate to="/login" replace />;
  }
  return children;
};

export function AppRouter() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/"
        element={
          <RequireAuth>
            <AppLayout />
          </RequireAuth>
        }
      >
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<DashboardPage />} />
        <Route path="sectors" element={<SectorsPage />} />
        <Route path="points" element={<PointsPage />} />
        <Route path="assignments" element={<AssignmentsPage />} />
        <Route path="export" element={<ExportPage />} />
      </Route>
      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  );
}
