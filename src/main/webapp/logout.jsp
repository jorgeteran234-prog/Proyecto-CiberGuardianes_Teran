<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Destruye toda la información de la sesión para que nadie más pueda usarla
    session.invalidate();
    // Lo envía de vuelta a la página de login
    response.sendRedirect("login.jsp");
%>