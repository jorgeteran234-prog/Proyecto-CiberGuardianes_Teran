<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ciber-Guardianes | Aprende Seguridad</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Comic Sans MS', cursive, sans-serif; 
            background: linear-gradient(180deg, #00d2ff 0%, #3a7bd5 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .navbar-custom { background-color: #212529; }
        
        .hero-title { 
            color: white; 
            font-weight: 900; 
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            margin-top: 40px;
            margin-bottom: 50px;
        }

        .tarjeta-giratoria {
            background-color: transparent;
            width: 100%;
            height: 380px;
            perspective: 1000px; 
            margin-bottom: 30px;
        }

        .tarjeta-interior {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s;
            transform-style: preserve-3d;
            cursor: pointer;
        }

        .tarjeta-giratoria:hover .tarjeta-interior {
            transform: rotateY(180deg);
        }

        .tarjeta-frente, .tarjeta-atras {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            border-radius: 25px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .tarjeta-frente {
            background-color: white;
            border: 5px solid transparent;
        }

        .frente-azul { border-color: #0d6efd; }
        .frente-rojo { border-color: #dc3545; }
        .frente-verde { border-color: #198754; }

        .icono-gigante { font-size: 5rem; margin-bottom: 15px; }

        .tarjeta-atras {
            color: white;
            transform: rotateY(180deg);
            padding: 30px;
        }

        .atras-azul { background-color: #0d6efd; border: 5px solid white; }
        .atras-rojo { background-color: #dc3545; border: 5px solid white; }
        .atras-verde { background-color: #198754; border: 5px solid white; }

        .footer {
            margin-top: auto;
            color: white;
            text-align: center;
            padding: 20px;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <!-- REPRODUCTORES DE SONIDO OCULTOS -->
    <audio id="sonidoGiro" preload="auto">
        <source src="https://assets.mixkit.co/active_storage/sfx/2568/2568-preview.mp3" type="audio/mpeg">
    </audio>
    
    <!-- AUDIO DE BURBUJAS DE BOB ESPONJA -->
    <audio id="sonidoBurbujas" preload="auto">
        <source src="https://www.myinstants.com/media/sounds/spongebob-bubbles.mp3" type="audio/mpeg">
    </audio>

    <!-- BARRA DE NAVEGACIÓN -->
    <nav class="navbar navbar-expand-lg navbar-custom shadow">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand text-white fw-bold fs-4" href="#">🛡️ CIBER-GUARDIANES</a>
            <div>
                <!-- Cambiamos los enlaces directos por la función de burbujas -->
                <button onclick="irConBurbujas('login.jsp')" class="btn btn-info text-white fw-bold me-2 rounded-pill shadow-sm">ENTRAR</button>
                <button onclick="irConBurbujas('registro.jsp')" class="btn btn-warning fw-bold rounded-pill shadow-sm">REGISTRO</button>
            </div>
        </div>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <div class="container text-center flex-grow-1">
        <h2 class="hero-title">Tu misión: Aprender a usar internet sin peligros.</h2>
        <p class="text-white fs-4 fw-bold mb-5">¡Pasa el ratón sobre las cartas para descubrir secretos! 🖱️✨</p>

        <div class="row justify-content-center">
            
            <!-- TARJETA 1: CLAVES -->
            <div class="col-md-4">
                <div class="tarjeta-giratoria" onmouseenter="reproducirSonido()">
                    <div class="tarjeta-interior">
                        <!-- Frente -->
                        <div class="tarjeta-frente frente-azul">
                            <div class="icono-gigante">🔐</div>
                            <h2 class="text-primary fw-bold">Super Claves</h2>
                            <p class="fs-5 text-secondary">¡Haz que tus contraseñas sean irrompibles!</p>
                            <button class="btn btn-primary btn-lg rounded-pill fw-bold w-75 mt-3">¡GÍRAME!</button>
                        </div>
                        <!-- Atrás -->
                        <div class="tarjeta-atras atras-azul">
                            <h3 class="fw-bold mb-3">💡 Sabías que...</h3>
                            <p class="fs-5">Tu contraseña es como la llave de tu casa. ¡Nunca se la des a extraños! Mezcla animales y números para hacerla fuerte.</p>
                            <button onclick="irConBurbujas('login.jsp')" class="btn btn-light text-primary btn-lg rounded-pill fw-bold mt-3 shadow">¡Entrenar Ahora!</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TARJETA 2: DETECTIVES -->
            <div class="col-md-4">
                <div class="tarjeta-giratoria" onmouseenter="reproducirSonido()">
                    <div class="tarjeta-interior">
                        <!-- Frente -->
                        <div class="tarjeta-frente frente-rojo">
                            <div class="icono-gigante">🕵️‍♂️</div>
                            <h2 class="text-danger fw-bold">Detectives</h2>
                            <p class="fs-5 text-secondary">¿Es un amigo o un truco? ¡Descúbrelo!</p>
                            <button class="btn btn-danger btn-lg rounded-pill fw-bold w-75 mt-3">¡GÍRAME!</button>
                        </div>
                        <!-- Atrás -->
                        <div class="tarjeta-atras atras-rojo">
                            <h3 class="fw-bold mb-3">💡 Sabías que...</h3>
                            <p class="fs-5">En internet no todos son quienes dicen ser. Si un extraño te pide fotos o tu dirección, ¡avísale rápido a un adulto!</p>
                            <button onclick="irConBurbujas('login.jsp')" class="btn btn-light text-danger btn-lg rounded-pill fw-bold mt-3 shadow">¡Modo Detective!</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TARJETA 3: ESCUDO -->
            <div class="col-md-4">
                <div class="tarjeta-giratoria" onmouseenter="reproducirSonido()">
                    <div class="tarjeta-interior">
                        <!-- Frente -->
                        <div class="tarjeta-frente frente-verde">
                            <div class="icono-gigante">🛡️</div>
                            <h2 class="text-success fw-bold">Mega Escudo</h2>
                            <p class="fs-5 text-secondary">¡Protege tu compu de los virus malos!</p>
                            <button class="btn btn-success btn-lg rounded-pill fw-bold w-75 mt-3">¡GÍRAME!</button>
                        </div>
                        <!-- Atrás -->
                        <div class="tarjeta-atras atras-verde">
                            <h3 class="fw-bold mb-3">💡 Sabías que...</h3>
                            <p class="fs-5">Los virus son bichitos invisibles que dañan tu computadora. ¡Nunca hagas clic en regalos mágicos sospechosos!</p>
                            <button onclick="irConBurbujas('login.jsp')" class="btn btn-light text-success btn-lg rounded-pill fw-bold mt-3 shadow">¡Activar Escudo!</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- FOOTER -->
    <div class="footer">
        Hecho con ❤️ para futuros Ciber-Héroes | ODS 4
    </div>

    <!-- SCRIPT PARA LOS SONIDOS Y LA TRANSICIÓN DE BURBUJAS -->
    <script>
        function reproducirSonido() {
            let sonido = document.getElementById("sonidoGiro");
            sonido.currentTime = 0; 
            sonido.play().catch(error => console.log("Esperando interacción para sonido de giro."));
        }

        // NUEVA FUNCIÓN: Reproduce burbujas, espera 800 milisegundos y viaja a la otra página
        function irConBurbujas(urlDestino) {
            let burbujas = document.getElementById("sonidoBurbujas");
            burbujas.currentTime = 0;
            burbujas.play().catch(error => console.log("Audio bloqueado por el navegador"));
            
            // Retraso de 0.8 segundos (800ms) para que se escuchen las burbujas antes de salir
            setTimeout(function() {
                window.location.href = urlDestino;
            }, 800);
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>