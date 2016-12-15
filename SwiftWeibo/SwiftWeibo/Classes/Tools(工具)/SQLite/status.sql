
-- 创建微博的数据表 --

CREATE TABLE IF NOT EXISTS "T_Status" (
    "statusid" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "status" TEXT,
    "creattime" TEXT DEFAULT (datetime('now','localtime')),
    PRIMARY KEY("statusid","userid")
);
