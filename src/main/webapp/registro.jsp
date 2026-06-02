<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String mensaje = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nombre = request.getParameter("txtNombre");
        String correo = request.getParameter("txtCorreo");
        String clave = request.getParameter("txtPassword");

        // VALIDACIÓN: Clave mínimo 8 caracteres (Requisito 2.1)
        if (nombre != null && correo != null && clave != null && clave.length() >= 8) {
            Connection con = null;
            PreparedStatement psUsuario = null;
            PreparedStatement psBitacora = null;
            try {
                Class.forName("org.postgresql.Driver");
                String url = "jdbc:postgresql://localhost:5433/seguridad_ninos";
                con = DriverManager.getConnection(url, "postgres", "159753");
                
                // Desactivar autocommit para usar transacciones (asegura que se guarden ambos o ninguno)
                con.setAutoCommit(false);

                // 1. Guardar el usuario
                String sqlUsuario = "INSERT INTO usuarios (nombre, correo, clave, rol, estado) VALUES (?, ?, ?, 'estudiante', true)";
                psUsuario = con.prepareStatement(sqlUsuario);
                psUsuario.setString(1, nombre);
                psUsuario.setString(2, correo);
                psUsuario.setString(3, clave);
                int filasUsuario = psUsuario.executeUpdate();

                // 2. Guardar en la Bitácora (NUEVO)
                if (filasUsuario > 0) {
                    String sqlBitacora = "INSERT INTO bitacora (nombre_usuario, accion) VALUES (?, ?)";
                    psBitacora = con.prepareStatement(sqlBitacora);
                    psBitacora.setString(1, nombre + " (" + correo + ")");
                    psBitacora.setString(2, "Registro de nuevo usuario exitoso");
                    psBitacora.executeUpdate();
                }

                // Confirmar transacción
                con.commit();
                response.sendRedirect("login.jsp?registro=ok");
                return;

            } catch (Exception e) {
                if (con != null) try { con.rollback(); } catch(Exception ex){}
                mensaje = "¡Oops! Hubo un problema: " + e.getMessage();
            } finally {
                if (psUsuario != null) try { psUsuario.close(); } catch(Exception e){}
                if (psBitacora != null) try { psBitacora.close(); } catch(Exception e){}
                if (con != null) try { con.close(); } catch(Exception e){}
            }
        } else {
            mensaje = "Recuerda: Tu clave debe tener al menos 8 caracteres.";
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro | Ciber-Guardianes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light" style="font-family: 'Comic Sans MS', cursive, sans-serif;">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-lg border-0 rounded-4" style="border-top: 8px solid #ff9100 !important;">
                    <div class="card-body p-5 text-center">
                        <h2 class="fw-bold mb-4" style="color: #ff9100;">🛡️ Únete al Equipo</h2>
                        
                        <% if (!mensaje.isEmpty()) { %>
                            <div class="alert alert-danger rounded-pill"><%= mensaje %></div>
                        <% } %>

                        <form method="POST" action="registro.jsp">
                            <div class="mb-3 text-start">
                                <label class="form-label fw-bold">¿Cómo te llamas? (Tu nombre de héroe)</label>
                                <input type="text" name="txtNombre" class="form-control rounded-pill" required placeholder="Ej: Leo, Sofi, Mateo...">
                            </div>
                            <div class="mb-3 text-start">
                                <label class="form-label fw-bold">Correo Electrónico</label>
                                <input type="email" name="txtCorreo" class="form-control rounded-pill" required placeholder="correo@ejemplo.com">
                            </div>
                            <div class="mb-3 text-start">
                                <label class="form-label fw-bold">Tu Clave Secreta</label>
                                <input type="password" name="txtPassword" class="form-control rounded-pill" minlength="8" required placeholder="Ej: Perro10!">
                                <div class="form-text">Mínimo 8 caracteres. ¡Usa números y letras!</div>
                            </div>
                            <button type="submit" class="btn btn-warning w-100 rounded-pill fw-bold py-2 fs-5 shadow-sm">¡REGISTRARME!</button>
                        </form>
                        
                        <div class="mt-3">
                            <a href="index.jsp" class="text-decoration-none text-secondary">Volver al inicio</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>