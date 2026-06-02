<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String mensaje = "";
    
    if ("ok".equals(request.getParameter("registro"))) {
        mensaje = "¡Registro exitoso! Ahora puedes entrar.";
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String correo = request.getParameter("txtCorreo");
        String clave = request.getParameter("txtPassword");

        Connection con = null;
        PreparedStatement psLogin = null;
        PreparedStatement psBitacora = null;
        ResultSet rs = null;
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://localhost:5433/seguridad_ninos"; 
            con = DriverManager.getConnection(url, "postgres", "159753");
            
            String sqlLogin = "SELECT id, nombre, rol, estado FROM usuarios WHERE correo = ? AND clave = ?";
            psLogin = con.prepareStatement(sqlLogin);
            psLogin.setString(1, correo);
            psLogin.setString(2, clave);
            
            rs = psLogin.executeQuery();
            
            if (rs.next()) {
                boolean estado = rs.getBoolean("estado");
                String nombreUsuario = rs.getString("nombre");

                if (!estado) {
                    mensaje = "Tu cuenta ha sido bloqueada. Habla con el profesor.";
                } else {
                    // Login exitoso: Guardar en SESIÓN
                    session.setAttribute("usuario_id", rs.getInt("id"));
                    session.setAttribute("usuario_nombre", nombreUsuario);
                    session.setAttribute("usuario_rol", rs.getString("rol"));
                    
                    // Login exitoso: Guardar en BITÁCORA (NUEVO)
                    String sqlBitacora = "INSERT INTO bitacora (nombre_usuario, accion) VALUES (?, ?)";
                    psBitacora = con.prepareStatement(sqlBitacora);
                    psBitacora.setString(1, nombreUsuario + " (" + correo + ")");
                    psBitacora.setString(2, "Inicio de sesión exitoso en el sistema");
                    psBitacora.executeUpdate();

                    if ("admin".equals(rs.getString("rol"))) {
                        response.sendRedirect("panel_admin.jsp");
                    } else {
                        response.sendRedirect("panel_estudiante.jsp");
                    }
                    return;
                }
            } else {
                mensaje = "Correo o clave incorrectos. ¡Intenta de nuevo!";
            }
        } catch (Exception e) {
            mensaje = "Error de sistema: " + e.getMessage();
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception e){}
            if (psLogin != null) try { psLogin.close(); } catch(Exception e){}
            if (psBitacora != null) try { psBitacora.close(); } catch(Exception e){}
            if (con != null) try { con.close(); } catch(Exception e){}
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Entrar | Ciber-Guardianes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light" style="font-family: 'Comic Sans MS', cursive, sans-serif;">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow-lg border-0 rounded-4" style="border-top: 8px solid #00d2ff !important;">
                    <div class="card-body p-5 text-center">
                        <h2 class="fw-bold mb-4" style="color: #00d2ff;">🚀 ¡A Jugar!</h2>
                        
                        <% if (!mensaje.isEmpty()) { 
                            String alertClass = mensaje.contains("exitoso") ? "alert-success" : "alert-danger";
                        %>
                            <div class="alert <%= alertClass %> rounded-pill fw-bold"><%= mensaje %></div>
                        <% } %>

                        <form method="POST" action="login.jsp">
                            <div class="mb-3 text-start">
                                <label class="form-label fw-bold">Tu Correo</label>
                                <input type="email" name="txtCorreo" class="form-control rounded-pill" required placeholder="correo@ejemplo.com">
                            </div>
                            <div class="mb-4 text-start">
                                <label class="form-label fw-bold">Tu Clave</label>
                                <input type="password" name="txtPassword" class="form-control rounded-pill" required placeholder="********">
                            </div>
                            <button type="submit" class="btn btn-info w-100 rounded-pill text-white fw-bold py-2 fs-5 shadow-sm" style="background-color: #00d2ff; border:none;">DESPEGAR</button>
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