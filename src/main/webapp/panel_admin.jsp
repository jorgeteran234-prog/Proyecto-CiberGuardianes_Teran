<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // SEGURIDAD: Solo entra si la sesión es de un admin
    String rol = (String) session.getAttribute("usuario_rol");
    if (rol == null || !rol.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // LÓGICA PARA BLOQUEAR O ACTIVAR USUARIOS
    String accion = request.getParameter("accion");
    String idUsuarioParam = request.getParameter("id");

    if (accion != null && idUsuarioParam != null) {
        Connection conUpdate = null;
        PreparedStatement psUpdate = null;
        try {
            Class.forName("org.postgresql.Driver");
            conUpdate = DriverManager.getConnection("jdbc:postgresql://localhost:5433/seguridad_ninos", "postgres", "159753");
            
            boolean nuevoEstado = accion.equals("activar");
            psUpdate = conUpdate.prepareStatement("UPDATE usuarios SET estado = ? WHERE id = ?");
            psUpdate.setBoolean(1, nuevoEstado);
            psUpdate.setInt(2, Integer.parseInt(idUsuarioParam));
            psUpdate.executeUpdate();
            
            // Redirigir para limpiar la URL y evitar que se repita la acción al recargar
            response.sendRedirect("panel_admin.jsp");
            return;
        } catch (Exception e) {
            out.println("<script>alert('Error al actualizar: " + e.getMessage() + "');</script>");
        } finally {
            if (psUpdate != null) try { psUpdate.close(); } catch(Exception e){}
            if (conUpdate != null) try { conUpdate.close(); } catch(Exception e){}
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Control Admin | Ciber-Guardianes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark shadow" aria-label="Navegación principal del administrador">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">⚙️ Panel de Administrador</a>
        <a href="logout.jsp" class="btn btn-danger btn-sm" aria-label="Cerrar sesión de administrador">Cerrar Sesión</a>
    </div>
</nav>

<div class="container mt-5 mb-5">
    
    <div class="card shadow border-0 mb-5">
        <div class="card-header bg-dark text-white fw-bold fs-5">
            👥 Gestión de Usuarios Registrados
        </div>
        <div class="card-body">
            <table class="table table-hover text-center align-middle">
                <thead class="table-dark">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Nombre</th>
                        <th scope="col">Correo</th>
                        <th scope="col">Rol</th>
                        <th scope="col">Estado</th>
                        <th scope="col">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("org.postgresql.Driver");
                            con = DriverManager.getConnection("jdbc:postgresql://localhost:5433/seguridad_ninos", "postgres", "159753");
                            
                            ps = con.prepareStatement("SELECT * FROM usuarios ORDER BY id ASC");
                            rs = ps.executeQuery();
                            
                            while(rs.next()) {
                                int idDb = rs.getInt("id");
                                String nombre = rs.getString("nombre");
                                String correo = rs.getString("correo");
                                String rolDb = rs.getString("rol");
                                boolean estado = rs.getBoolean("estado");
                    %>
                                <tr>
                                    <td><%= idDb %></td>
                                    <td class="fw-bold"><%= nombre != null ? nombre : "N/A" %></td>
                                    <td><%= correo %></td>
                                    <td><span class="badge bg-secondary"><%= rolDb.toUpperCase() %></span></td>
                                    <td>
                                        <% if(estado) { %>
                                            <span class="badge bg-success">Activo</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Bloqueado</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if(rolDb.equals("admin")) { %>
                                            <span class="text-muted">No aplica</span>
                                        <% } else if(estado) { %>
                                            <a href="panel_admin.jsp?accion=bloquear&id=<%= idDb %>" class="btn btn-warning btn-sm fw-bold">Bloquear 🛑</a>
                                        <% } else { %>
                                            <a href="panel_admin.jsp?accion=activar&id=<%= idDb %>" class="btn btn-success btn-sm fw-bold">Activar ✅</a>
                                        <% } %>
                                    </td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch(Exception e){}
                            if (ps != null) try { ps.close(); } catch(Exception e){}
                            if (con != null) try { con.close(); } catch(Exception e){}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card shadow border-0 border-top border-info border-4">
        <div class="card-header bg-white text-info fw-bold fs-5">
            📋 Bitácora del Sistema (Historial)
        </div>
        <div class="card-body">
            <div style="max-height: 300px; overflow-y: auto;">
                <table class="table table-striped table-sm text-center">
                    <thead class="table-info">
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Usuario</th>
                            <th scope="col">Actividad Realizada</th>
                            <th scope="col">Fecha y Hora</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conBit = null;
                            PreparedStatement psBit = null;
                            ResultSet rsBit = null;
                            try {
                                Class.forName("org.postgresql.Driver");
                                conBit = DriverManager.getConnection("jdbc:postgresql://localhost:5433/seguridad_ninos", "postgres", "159753");
                                
                                // Consultar la bitácora ordenada desde lo más reciente
                                psBit = conBit.prepareStatement("SELECT * FROM bitacora ORDER BY fecha DESC");
                                rsBit = psBit.executeQuery();
                                
                                while(rsBit.next()) {
                        %>
                                    <tr>
                                        <td><%= rsBit.getInt("id") %></td>
                                        <td class="fw-bold"><%= rsBit.getString("nombre_usuario") %></td>
                                        <td class="text-start"><%= rsBit.getString("accion") %></td>
                                        <td class="text-muted"><%= rsBit.getTimestamp("fecha") %></td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='4' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                if (rsBit != null) try { rsBit.close(); } catch(Exception e){}
                                if (psBit != null) try { psBit.close(); } catch(Exception e){}
                                if (conBit != null) try { conBit.close(); } catch(Exception e){}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>