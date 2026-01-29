import { jwtDecode } from './jwt';

const TOKEN_KEY = 'admin_token';

export const authService = {
  getToken(): string | null {
    return localStorage.getItem(TOKEN_KEY);
  },
  setToken(token: string): void {
    localStorage.setItem(TOKEN_KEY, token);
  },
  clearToken(): void {
    localStorage.removeItem(TOKEN_KEY);
  },
  getRole(token: string): string | null {
    try {
      const payload = jwtDecode(token);
      return typeof payload.role === 'string' ? payload.role : null;
    } catch {
      return null;
    }
  }
};
