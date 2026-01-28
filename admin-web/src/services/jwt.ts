export type JwtPayload = {
  sub?: string;
  role?: string;
  exp?: number;
};

export function jwtDecode(token: string): JwtPayload {
  const parts = token.split('.');
  if (parts.length !== 3) {
    throw new Error('Invalid token');
  }
  const payload = JSON.parse(atob(parts[1]));
  return payload as JwtPayload;
}
