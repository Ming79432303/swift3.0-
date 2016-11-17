
-- 创建微博数据 --

CREATE TABLE IF NOT EXISTS "T_status" (
"statusid" INTEGER NOT NULL,
"userid" INTEGER NOT NULL,
"status" TEXT,
"createTime" TEXT DEFAULT (datetime('now','localtime')),
PRIMARY KEY("statusid","userid")
)
