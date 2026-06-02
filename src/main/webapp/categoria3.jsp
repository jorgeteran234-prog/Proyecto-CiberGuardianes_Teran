<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String nombreUsuario = (String) session.getAttribute("usuario_nombre");
    if (nombreUsuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conBit3 = null;
    PreparedStatement psBit3 = null;
    try {
        Class.forName("org.postgresql.Driver");
        conBit3 = DriverManager.getConnection("jdbc:postgresql://localhost:5433/seguridad_ninos", "postgres", "159753");
        psBit3 = conBit3.prepareStatement("INSERT INTO bitacora (nombre_usuario, accion) VALUES (?, ?)");
        psBit3.setString(1, nombreUsuario);
        psBit3.setString(2, "Ingresó al Nivel Final: Ataque de Virus");
        psBit3.executeUpdate();
    } catch (Exception e) {
        System.out.println("Error al registrar bitácora Nivel 3: " + e.getMessage());
    } finally {
        if (psBit3 != null) try { psBit3.close(); } catch(Exception e){}
        if (conBit3 != null) try { conBit3.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nivel 3: Escudo Antivirus 🛡️</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.1.1/model-viewer.min.js"></script>
    
    <style>
        body { background-color: #e8f5e9; font-family: 'Comic Sans MS', cursive, sans-serif; }
        .caja-juego { background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); border: 4px dashed #4caf50; }
        
        model-viewer { 
            width: 100%; 
            height: 380px; 
            border-radius: 15px; 
            background: radial-gradient(circle, #ffeb3b 0%, #fb8c00 50%, #e65100 100%); 
            box-shadow: inset 0 0 50px rgba(0,0,0,0.3);
        }
        
        #area-juego {
            position: relative;
            width: 100%;
            height: 320px;
            background-color: #000; 
            border-radius: 15px;
            border: 5px solid #4caf50;
            overflow: hidden;
            background-image: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06));
            background-size: 100% 4px, 3px 100%;
        }
        
        .virus-enemigo {
            position: absolute;
            font-size: 3rem;
            cursor: pointer;
            transition: transform 0.1s;
            user-select: none;
            filter: drop-shadow(0 0 10px #ff0000);
        }
        
        .virus-enemigo:hover { transform: scale(1.2); }

        .instruccion-final {
            color: #ff0000;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 2px;
            animation: parpadeo 0.8s infinite;
        }

        .titilante { animation: parpadeo 1s infinite alternate; }

        @keyframes parpadeo {
            0% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.7; transform: scale(1.05); }
            100% { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>

    <audio id="sonidoBurbujas" preload="auto">
        <source src="https://www.myinstants.com/media/sounds/spongebob-bubbles.mp3" type="audio/mpeg">
    </audio>
    <audio id="musicaVictoria" loop preload="auto">
        <source src="multimedia/victoria.mp3" type="audio/mpeg">
        <source src="https://assets.mixkit.co/active_storage/sfx/1435/1435-preview.mp3" type="audio/mpeg">
    </audio>

    <nav class="navbar navbar-dark shadow-sm mb-4" style="background-color: #2e7d32;">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#" onclick="irConBurbujas('panel_estudiante.jsp'); return false;">⬅️ Volver a la Base</a>
            <span class="text-white fw-bold fs-5">Capitán: <%= session.getAttribute("usuario_nombre") %> 🚀</span>
        </div>
    </nav>

    <div class="container mb-5 text-center">
        <h1 class="fw-bold text-success mb-2">Nivel Final: ¡Ataque de Virus! 🦠🔥</h1>
        <p class="fs-5 mb-4 text-secondary">El sistema está bajo ataque. ¡Usa tus reflejos para limpiar la memoria!</p>

        <div class="row justify-content-center g-4">
            <div class="col-md-6">
                <div class="caja-juego h-100 d-flex flex-column justify-content-center">
                    <h2 class="instruccion-final mb-3" id="texto-instruccion">¡PULSA LOS VIRUS PARA DESTRUIRLOS! 💥</h2>
                    <h4 id="score-text" class="text-dark fw-bold mb-3">Virus capturados: 0 / 10</h4>
                    
                    <div id="area-juego" class="shadow-lg">
                        <div class="d-flex h-100 justify-content-center align-items-center">
                            <button id="btn-iniciar" class="btn btn-danger btn-lg rounded-pill fw-bold fs-3 px-5 shadow-lg" onclick="iniciarJuego()">🛰️ ACTIVAR RADAR</button>
                        </div>
                    </div>

                    <div id="zona-victoria" style="display: none;" class="mt-4">
                        <button type="button" class="btn btn-warning btn-lg rounded-pill fw-bold fs-4 px-5 shadow border-white border-3 titilante" data-bs-toggle="modal" data-bs-target="#premioModal">
                            ¡Lo lograste! Recibe tu premio 🎁
                        </button>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="caja-juego h-100">
                    <h3 class="text-warning fw-bold mb-3">Nave de Limpieza 🚀</h3>
                    <p class="fs-5">¡Esta nave patrulla los datos buscando amenazas!</p>
                    <model-viewer src="https://modelviewer.dev/shared-assets/models/RocketShip.glb" alt="Nave Espacial 3D" auto-rotate camera-controls shadow-intensity="1"></model-viewer>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="premioModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 25px; border: 6px solid #ff9800; background-color: #fff8e1;">
          <div class="modal-header border-0 pb-0 justify-content-center text-center">
            <h2 class="modal-title fw-bold text-danger w-100 mt-3">🏆 ¡MISIÓN CUMPLIDA! 🏆</h2>
          </div>
          <div class="modal-body text-center px-4">
            <h4 class="text-success fw-bold mb-3">¡Eres digno, <%= session.getAttribute("usuario_nombre") %>! Eres un campeón de la seguridad cibernética. 🛡️💻</h4>
            
            <div id="contenedor-premio" class="mb-3"></div>
            
          </div>
          <div class="modal-footer border-0 pt-0 justify-content-center">
            <button onclick="detenerMusicaEIr('panel_estudiante.jsp')" class="btn btn-primary btn-lg rounded-pill fw-bold fs-4 px-5 shadow mb-3">Volver a la Base 🚀</button>
          </div>
        </div>
      </div>
    </div>

    <script>
        let puntaje = 0;
        let intervaloJuego;

        function iniciarJuego() {
            puntaje = 0;
            document.getElementById("score-text").innerText = "Virus capturados: " + puntaje + " / 10";
            document.getElementById("btn-iniciar").style.display = "none";
            document.getElementById("area-juego").innerHTML = "";
            intervaloJuego = setInterval(crearVirus, 700); 
        }

        function crearVirus() {
            let area = document.getElementById("area-juego");
            let virus = document.createElement("span");
            const emojis = ["👾", "🦠", "💣", "🐛", "🔥"];
            virus.innerText = emojis[Math.floor(Math.random() * emojis.length)];
            virus.className = "virus-enemigo";
            
            let posX = Math.random() * (area.offsetWidth - 60);
            let posY = Math.random() * (area.offsetHeight - 60);
            virus.style.left = posX + "px";
            virus.style.top = posY + "px";

            virus.onclick = function() {
                this.style.transform = "scale(0)"; 
                setTimeout(() => this.remove(), 100);
                puntaje++;
                document.getElementById("score-text").innerText = "Virus capturados: " + puntaje + " / 10";
                if (puntaje >= 10) ganarJuego();
            };
            area.appendChild(virus);
            setTimeout(() => { if(virus.parentElement) virus.remove(); }, 1500);
        }

        function ganarJuego() {
            clearInterval(intervaloJuego);
            let area = document.getElementById("area-juego");
            area.style.backgroundColor = "#00c853";
            area.style.backgroundImage = "none";
            area.innerHTML = "<div class='d-flex h-100 justify-content-center align-items-center flex-column'><h1 style='font-size: 6rem;'>🛸</h1><h2 class='text-white fw-bold'>SISTEMA DESINFECTADO</h2></div>";
            
            document.getElementById("zona-victoria").style.display = "block";
            document.getElementById("texto-instruccion").style.display = "none";
            
            // INYECTAR EL VIDEO DE BOB ESPONJA CON INICIO EN 0:37 Y FIN EN 0:49
            // Se usa pointer-events:none para que no lo puedan pausar ni salir a YouTube (comportamiento de GIF)
            document.getElementById("contenedor-premio").innerHTML = '<iframe src="https://www.youtube.com/embed/9cgRaes3C_Q?start=37&end=49&autoplay=1&mute=1&controls=0&disablekb=1&fs=0&modestbranding=1" width="100%" height="250" style="border: 4px solid #ff9800; border-radius: 15px; pointer-events: none;" allow="autoplay"></iframe>';
            
            let victoriaAudio = document.getElementById("musicaVictoria");
            victoriaAudio.volume = 0.8;
            victoriaAudio.play().catch(error => console.log("Interacción requerida para reproducir música."));
        }

        function detenerMusicaEIr(urlDestino) {
            let victoriaAudio = document.getElementById("musicaVictoria");
            victoriaAudio.pause(); 
            irConBurbujas(urlDestino);
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