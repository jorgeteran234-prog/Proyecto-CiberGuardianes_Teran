<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("usuario_nombre") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Panel | Ciber-Guardianes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #e0f7fa; font-family: 'Comic Sans MS', cursive, sans-serif;">

<nav class="navbar navbar-dark bg-primary shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">🛡️ Base de Ciber-Guardianes</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3 fw-bold fs-5">¡Hola, <%= session.getAttribute("usuario_nombre") %>! 🦸‍♂️🚀</span>
            <a href="logout.jsp" class="btn btn-danger btn-sm fw-bold">Salir</a>
        </div>
    </div>
</nav>

<div class="container mt-5 text-center">
    <h1 class="fw-bold text-primary mb-4">¡Bienvenido a tus Misiones! 🚀</h1>
    <div class="row justify-content-center g-4">
        
        <div class="col-md-4">
            <div class="card shadow-lg border-0 rounded-4 h-100">
                <div class="card-body p-4">
                    <h1 style="font-size: 4rem;">🔑</h1>
                    <h3 class="fw-bold text-primary">Nivel 1</h3>
                    <p>Crea tu Super Clave Mágica.</p>
                    <a href="categoria1.jsp" class="btn btn-primary w-100 rounded-pill fw-bold">¡JUGAR!</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-lg border-0 rounded-4 h-100">
                <div class="card-body p-4">
                    <h1 style="font-size: 4rem;">🕵️‍♂️</h1>
                    <h3 class="fw-bold text-danger">Nivel 2</h3>
                    <p>Detectives de Mentiras.</p>
                    <a href="categoria2.jsp" class="btn btn-danger w-100 rounded-pill fw-bold">¡JUGAR!</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-lg border-0 rounded-4 h-100">
                <div class="card-body p-4">
                    <h1 style="font-size: 4rem;">🛡️</h1>
                    <h3 class="fw-bold text-success">Nivel 3</h3>
                    <p>Escudo contra Virus.</p>
                    <a href="categoria3.jsp" class="btn btn-success w-100 rounded-pill fw-bold">¡JUGAR!</a>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>