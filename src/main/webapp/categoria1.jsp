<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String nombreUsuario = (String) session.getAttribute("usuario_nombre");
    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conBit1 = null;
    PreparedStatement psBit1 = null;
    try {
        Class.forName("org.postgresql.Driver");
        conBit1 = DriverManager.getConnection("jdbc:postgresql://localhost:5433/seguridad_ninos", "postgres", "159753");
        psBit1 = conBit1.prepareStatement("INSERT INTO bitacora (nombre_usuario, accion) VALUES (?, ?)");
        psBit1.setString(1, nombreUsuario);
        psBit1.setString(2, "Ingresó al Nivel 1: Forja tu Super Clave");
        psBit1.executeUpdate();
    } catch (Exception e) {
        System.out.println("Error al registrar bitácora Nivel 1: " + e.getMessage());
    } finally {
        if (psBit1 != null) try { psBit1.close(); } catch(Exception e){}
        if (conBit1 != null) try { conBit1.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nivel 1: Super Claves 🔑</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.1.1/model-viewer.min.js"></script>
    
    <style>
        body { 
            background-color: #e0f7fa; 
            font-family: 'Comic Sans MS', cursive, sans-serif; 
        }
        .caja-multimedia { 
            background: white; 
            border-radius: 20px; 
            padding: 20px; 
            box-shadow: 0 10px 20px rgba(0,0,0,0.1); 
            border: 4px dashed #00d2ff; 
        }
        
        model-viewer { 
            width: 100%; 
            height: 350px; 
            border-radius: 15px;
            background-color: #2b004d; 
            background-image:
              radial-gradient(2px 2px at 20px 30px, #ffffff, rgba(0,0,0,0)),
              radial-gradient(2px 2px at 40px 70px, #ffffff, rgba(0,0,0,0)),
              radial-gradient(2px 2px at 50px 160px, #dddddd, rgba(0,0,0,0)),
              radial-gradient(2px 2px at 90px 40px, #ffffff, rgba(0,0,0,0)),
              radial-gradient(2px 2px at 130px 80px, #ffffff, rgba(0,0,0,0)),
              radial-gradient(2px 2px at 160px 120px, #dddddd, rgba(0,0,0,0)),
              radial-gradient(3px 3px at 200px 50px, #ffffff, rgba(0,0,0,0));
            background-repeat: repeat;
        }
        
        .btn-ar { 
            background-color: #ff9100; 
            color: white; 
            border: none; 
            padding: 10px 20px; 
            border-radius: 10px; 
            font-weight: bold; 
            cursor: pointer; 
        }
    </style>
</head>
<body>

    <audio id="sonidoBurbujas" preload="auto">
        <source src="https://www.myinstants.com/media/sounds/spongebob-bubbles.mp3" type="audio/mpeg">
    </audio>

    <nav class="navbar navbar-dark bg-primary shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#" onclick="irConBurbujas('panel_estudiante.jsp'); return false;">⬅️ Volver a la Base</a>
            <span class="text-white fw-bold fs-5">Jugador: <%= session.getAttribute("usuario_nombre") %> 🦸‍♂️</span>
        </div>
    </nav>

    <div class="container mb-5">
        <h1 class="text-center fw-bold text-primary mb-4">Nivel 1: ¡Forja tu Super Clave! 🔐</h1>

        <div class="text-center mb-5 bg-white p-3 rounded-pill shadow-sm w-75 mx-auto border border-warning">
            <p class="fw-bold fs-5 text-warning mb-2">🎧 Computadora Central: Escucha tu misión</p>
            <audio controls>
                <source src="multimedia/mision1.mp3" type="audio/mpeg">
                Tu navegador no soporta el audio.
            </audio>
        </div>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="caja-multimedia h-100 text-center">
                    <h3 class="text-danger fw-bold mb-3">Mira cómo hacerlo 👀</h3>
                    <div class="ratio ratio-16x9 mb-3 shadow-sm rounded">
                        <iframe src="https://www.youtube.com/embed/pS6sf2BwmWY" title="Video" allowfullscreen></iframe>
                    </div>
                    <p class="fs-5">Una buena contraseña es como un perro guardián. ¡Debe ser fuerte para proteger tus secretos!</p>
                </div>
            </div>

            <div class="col-md-6">
                <div class="caja-multimedia h-100 text-center">
                    <h3 class="text-success fw-bold mb-3">¡Mueve al Guardián! 🖐️</h3>
                    <p class="fs-5">Gíralo para buscar pistas espaciales.</p>
                    
                    <model-viewer 
                        src="https://modelviewer.dev/shared-assets/models/Astronaut.glb" 
                        alt="Modelo 3D" 
                        auto-rotate 
                        camera-controls 
                        ar 
                        ar-modes="webxr scene-viewer quick-look">
                        <button slot="ar-button" class="btn-ar mt-3 shadow">📲 Ver en tu Cuarto (AR)</button>
                    </model-viewer>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-5">
            <button onclick="irConBurbujas('categoria2.jsp')" class="btn btn-success btn-lg rounded-pill fw-bold fs-4 px-5 shadow shadow-lg" style="border: 3px solid #fff;">
                ¡Misión Cumplida! Ir al Nivel 2 ➡️
            </button>
        </div>
    </div>

    <script>
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