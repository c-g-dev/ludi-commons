package ludi.commons.pattern;

class StaticBlock {
	public function new(func: () -> Void) {
        func();
    }
}

class StaticInit {
	public static function init<T>(func: () -> T): T {
        return func();
    }
}


class StaticScheduled {
    static var SCHEDULED_JOBS: Array<{func: () -> Void, options: Array<StaticSchedulerOption>}> = [];
    static var EXECUTED_JOBS: Array<String> = [];

    public static function taggedInit<T>(tag: String, func: () -> T): T {
        EXECUTED_JOBS.push(tag);
        return func();
    }
    
    public function new(func: () -> Void, options: Array<StaticSchedulerOption>) {
        var executeNow = true;
        var currentTag: String = null;
        var dependencies: Array<String> = [];

        for (option in options) {
            switch option {
                case Tag(tag):
                    currentTag = tag;
                case ExecuteAfter(tag):
                    executeNow = EXECUTED_JOBS.indexOf(tag) != -1;
                    dependencies.push(tag);
            }
        }

        if (executeNow) {
            func();
            if (currentTag != null) {
                EXECUTED_JOBS.push(currentTag);
            }
            executeDependentJobs();
        } else {
            SCHEDULED_JOBS.push({ func: func, options: options });
        }
    }
    
    static function executeDependentJobs() {
        for (job in SCHEDULED_JOBS) {
            var canExecute = true;
            for (option in job.options) {
                switch option {
                    case ExecuteAfter(tag):{
                        if (EXECUTED_JOBS.indexOf(tag) == -1) {
                            canExecute = false;
                        }
                    }
                    default:
                }
            }
            
            if (canExecute) {
                job.func();
                for (option in job.options) {
                    switch option {
                        case Tag(tag): {
                            if (EXECUTED_JOBS.indexOf(tag) == -1) {
                                EXECUTED_JOBS.push(tag);
                            }
                        }
                        default:
                    }
                }
            }
        }
    }
}

enum StaticSchedulerOption {
    Tag(tag: String);
    ExecuteAfter(tag: String);
}