package com.github.vtitov.testing.jenkins.robot;

import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class SunHttpServer0 {
    public static HttpServer createHttpServer() throws IOException {
        return createHttpServer(0);
    }
    public static HttpServer createHttpServer(Integer port) throws IOException {
        return createHttpServer(port,"/java");
    }
    public static HttpServer createHttpServer(Integer port, String prefix) throws IOException {
        String payload = "duke";
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        HttpContext context = server.createContext("/java");
        context.setHandler((he) -> {
            he.sendResponseHeaders(200, payload.getBytes("UTF-8").length);
            final OutputStream output = he.getResponseBody();
            output.write(payload.getBytes("UTF-8"));
            output.flush();
            he.close();
        });
        server.start();
        System.out.println("*INFO:" + System.currentTimeMillis() + "* Service running at " + server.getAddress().getPort());
        return server;
    }


    final HttpServer httpServer;

    final String contextPath;

    private HttpServer getHttpServer() {
        return httpServer;
    }

    private String getContextPath() {
        return contextPath;
    }

    public Integer getPort() {
        return getHttpServer().getAddress().getPort();
    }

    public String getServerUrl() {
        Integer port = getHttpServer().getAddress().getPort();
        String host = getHttpServer().getAddress().getHostString();
        return "http://" + host + ":" + port + getContextPath();
    }

    public SunHttpServer0() throws IOException {
        this.contextPath = "/java";
        this.httpServer = createHttpServer(0, "/java");
    }
    SunHttpServer0(Integer port, String contextPath) throws IOException {
        this.contextPath = contextPath;
        this.httpServer = createHttpServer(port, contextPath);
    }
}
