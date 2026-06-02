<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String nombreUsuario = (String) session.getAttribute("usuario_nombre");
    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conBit2 = null;
    PreparedStatement psBit2 = null;
    try {
        Class.forName("org.postgresql.Driver");
        conBit2 = DriverManager.getConnection("jdbc:postgresql://localhost:5433/seguridad_ninos", "postgres", "159753");
        psBit2 = conBit2.prepareStatement("INSERT INTO bitacora (nombre_usuario, accion) VALUES (?, ?)");
        psBit2.setString(1, nombreUsuario);
        psBit2.setString(2, "Ingresó al Nivel 2: Detectives de Mentiras");
        psBit2.executeUpdate();
    } catch (Exception e) {
        System.out.println("Error al registrar bitácora Nivel 2: " + e.getMessage());
    } finally {
        if (psBit2 != null) try { psBit2.close(); } catch(Exception e){}
        if (conBit2 != null) try { conBit2.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nivel 2: Detectives 🕵️‍♂️</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.1.1/model-viewer.min.js"></script>
    
    <style>
        body { background-color: #fff3e0; font-family: 'Comic Sans MS', cursive, sans-serif; }
        .caja-juego { background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); border: 4px dashed #ff5722; }
        model-viewer { width: 100%; height: 350px; border-radius: 15px; background-color: #f8f9fa; }
        .btn-enlace { font-size: 1.1rem; border-radius: 15px; transition: transform 0.2s; white-space: normal;}
        .btn-enlace:hover { transform: scale(1.03); }
    </style>
</head>
<body>

    <audio id="sonidoBurbujas" preload="auto">
        <source src="https://www.myinstants.com/media/sounds/spongebob-bubbles.mp3" type="audio/mpeg">
    </audio>

    <nav class="navbar navbar-dark shadow-sm mb-4" style="background-color: #ff5722;">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#" onclick="irConBurbujas('panel_estudiante.jsp'); return false;">⬅️ Volver a la Base</a>
            <span class="text-white fw-bold fs-5">Detective: <%= session.getAttribute("usuario_nombre") %> 🔍</span>
        </div>
    </nav>

    <div class="container mb-5 text-center">
        <h1 class="fw-bold text-danger mb-4">Nivel 2: ¡Detectives de Mentiras! 🕵️‍♂️</h1>
        <p class="fs-4 mb-5">Los villanos intentan engañarte. ¿Podrás descubrir la trampa?</p>

        <div class="row justify-content-center g-4">
            <div class="col-md-6">
                <div class="caja-juego h-100 d-flex flex-column justify-content-center" id="contenedor-juego">
                    
                    <div id="pregunta1">
                        <h3 class="text-warning fw-bold mb-3">Misión 1: El Regalo Sospechoso 🎁</h3>
                        <p class="fs-5 mb-4">Te llegó un mensaje: <em>"¡Ganaste 1000 diamantes gratis! Haz clic aquí abajo"</em>.</p>
                        <button class="btn btn-outline-danger w-100 btn-enlace fw-bold py-3 mb-3 shadow-sm" onclick="responder(1, false)">🌐 Clic aquí: www.diamantes-gratis-real.com/login</button>
                        <button class="btn btn-outline-success w-100 btn-enlace fw-bold py-3 shadow-sm" onclick="responder(1, true)">🛑 ¡Cierro el mensaje y le digo a un adulto!</button>
                    </div>

                    <div id="pregunta2" style="display: none;">
                        <h3 class="text-primary fw-bold mb-3">Misión 2: El Falso Amigo 🎮</h3>
                        <p class="fs-5 mb-4">Un jugador desconocido te dice: <em>"Dame tu contraseña y te construyo un castillo"</em>.</p>
                        <button class="btn btn-outline-danger w-100 btn-enlace fw-bold py-3 mb-3 shadow-sm" onclick="responder(2, false)">🤩 ¡Claro! Toma mi clave.</button>
                        <button class="btn btn-outline-success w-100 btn-enlace fw-bold py-3 shadow-sm" onclick="responder(2, true)">🙅‍♂️ ¡No! Mi contraseña es secreta. Lo bloqueo.</button>
                    </div>
                    
                    <div id="resultado-final" style="display: none;">
                        <div id="mensaje-resultado"></div>
                        <button id="btn-intentar" class="btn btn-warning btn-lg rounded-pill fw-bold fs-5 px-4 shadow mt-4" style="display: none;" onclick="reiniciarJuego()">🔄 Intentar de nuevo</button>
                        <button id="btn-siguiente" onclick="irConBurbujas('categoria3.jsp')" class="btn btn-success btn-lg rounded-pill fw-bold fs-4 px-4 shadow mt-4" style="display: none;">¡Misión Cumplida! Ir al Nivel 3 ➡️</button>
                    </div>

                </div>
            </div>

            <div class="col-md-6">
                <div class="caja-juego h-100">
                    <h3 class="text-info fw-bold mb-3">Robot Analizador 🤖</h3>
                    <p class="fs-5">Gira al robot. ¡Él te ayudará a escanear las mentiras de internet!</p>
                    <model-viewer src="https://modelviewer.dev/shared-assets/models/RobotExpressive.glb" alt="Robot 3D" auto-rotate camera-controls animation-name="Wave"></model-viewer>
                </div>
            </div>
        </div>
    </div>

    <script>
        function responder(numeroPregunta, esCorrecto) {
            let p1 = document.getElementById("pregunta1");
            let p2 = document.getElementById("pregunta2");
            let resultadoFinal = document.getElementById("resultado-final");
            let mensaje = document.getElementById("mensaje-resultado");
            let btnIntentar = document.getElementById("btn-intentar");
            let btnSiguiente = document.getElementById("btn-siguiente");

            if (esCorrecto) {
                if (numeroPregunta === 1) {
                    p1.style.display = "none";
                    p2.style.display = "block";
                } else if (numeroPregunta === 2) {
                    p2.style.display = "none";
                    resultadoFinal.style.display = "block";
                    mensaje.innerHTML = "¡Felicidades! 🌟 Eres un verdadero Detective de Mentiras.";
                    mensaje.className = "fw-bold fs-4 text-success p-4 bg-success bg-opacity-10 rounded-3 border border-success";
                    btnSiguiente.style.display = "inline-block";
                    btnIntentar.style.display = "none";
                }
            } else {
                p1.style.display = "none";
                p2.style.display = "none";
                resultadoFinal.style.display = "block";
                mensaje.innerHTML = "¡Oh no! 👾 Caíste en la trampa. Recuerda que los regalos mágicos suelen ser mentiras.";
                mensaje.className = "fw-bold fs-4 text-danger p-4 bg-danger bg-opacity-10 rounded-3 border border-danger";
                btnIntentar.style.display = "inline-block";
                btnSiguiente.style.display = "none";
            }
        }
        function reiniciarJuego() {
            document.getElementById("resultado-final").style.display = "none";
            document.getElementById("pregunta2").style.display = "none";
            document.getElementById("pregunta1").style.display = "block";
        }
        function irConBurbujas(urlDestino) {
            let burbujas = document.getElementById("sonidoBurbujas");
            burbujas.currentTime = 0;
            burbujas.play().catch(error => console.log("Audio bloqueado"));
            setTimeout(function() { window.location.href = urlDestino; }, 800);
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>