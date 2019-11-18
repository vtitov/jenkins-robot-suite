package com.github.vtitov.testing.jenkins.robot;

import lombok.Getter;
import lombok.experimental.Delegate;
import static ru.sbrf.bdata.ctl.robot.RobotLogging.*;

public class LoremIpsum {

    @Delegate(types=com.thedeanda.lorem.Lorem.class)
    private final com.thedeanda.lorem.Lorem lorem;

    @Getter
    private final Long seed;

    public LoremIpsum() {
        info("New LoremIpsum without seed ");
        seed = null;
        lorem = new com.thedeanda.lorem.LoremIpsum(/*this.seed*/);
    }

    public LoremIpsum(Long seed) {
        info("New LoremIpsum with seed " + seed);
        this.seed = seed;
        lorem = new com.thedeanda.lorem.LoremIpsum(this.seed);
    }
}


