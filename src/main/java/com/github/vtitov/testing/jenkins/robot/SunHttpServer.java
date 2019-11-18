package com.github.vtitov.testing.jenkins.robot;

import org.robotframework.javalib.annotation.Autowired;
import org.robotframework.javalib.library.AnnotationLibrary;
import com.github.vtitov.testing.jenkins.robot.keywords.http.SunHttpServerKW;

import java.util.ArrayList;

public class SunHttpServer extends AnnotationLibrary {
    @Override
    public String getKeywordDocumentation(String keywordName) {
        if (keywordName.equals("__intro__"))
            return "This is the general library documentation.";
        return super.getKeywordDocumentation(keywordName);
    }

    public SunHttpServer() {
        super(
            new ArrayList<String>() {{
                //add("com/acme/**/keyword/**/*.class");
                //add("org/some/other/place/**.class");
                //add("ru/sbrf/bdata/ctl/robot/keywords/**.class");
                add("com/github/vtitov/testing/jenkins/robot/keywords/http/**.class");
            }}
        );
    }

    @Autowired
    SunHttpServerKW sunHttpServerKW;

}
