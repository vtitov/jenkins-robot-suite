package com.github.vtitov.testing.jenkins.robot.keywords.http;

import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpServer;
import org.robotframework.javalib.annotation.ArgumentNames;
import org.robotframework.javalib.annotation.RobotKeyword;
import org.robotframework.javalib.annotation.RobotKeywords;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

@RobotKeywords
public class SunHttpServerKW {

    private static final String DEFAULT_PREFIX = "/java";

    @RobotKeyword(
        "Launches http server.\n\n"
            + "Example:\n"
            + "| Launch Application | _com.acme.myapplication.MyApp_ | _--data-file_ | _C:\\data.txt_ |\n")
    public HttpServer defaultHttpServer() throws IOException {
        return createHttpServer(0, DEFAULT_PREFIX);
    }

    @RobotKeyword
    @ArgumentNames({"server"})
    public void httpServerInfo(HttpServer server) throws IOException {
        System.out.println("*INFO:" + System.currentTimeMillis() + "* Service running at " + server.getAddress().getPort());
    }

    @RobotKeyword
    @ArgumentNames({"server"})
    public String httpServerURL(HttpServer server) throws IOException {
        return "http://" + "localhost" + ":" + server.getAddress().getPort();
//        return "http://" + server.getAddress().getHostString() + ":" + server.getAddress().getPort();
    }

    @RobotKeyword(
        "Launches http server.\n\n"
            + "Example:\n"
            + "| Launch Application | _com.acme.myapplication.MyApp_ | _--data-file_ | _C:\\data.txt_ |\n")
    @ArgumentNames({"port", "prefix"})
    public HttpServer createHttpServer(Integer port, String prefix) throws IOException {
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
        return server;
    }

    @RobotKeyword
    @ArgumentNames({"message"})
    public void dummyHttpServerPrint (String message) throws IOException {
        System.out.println(message);
    }
}
