from enum import Enum


class UserRole(str, Enum):
    admin = "ADMIN"
    capataz = "CAPATAZ"


class FormType(str, Enum):
    purga = "PURGA"
    vpa = "VPA"
    generic = "GENERIC"


class ExecutionStatus(str, Enum):
    pendiente = "PENDIENTE"
    resuelto = "RESUELTO"
    imposibilidad = "IMPOSIBILIDAD"
    reprogramacion = "REPROGRAMACION"
