const cron = require('node-cron');
const prisma = require("../utils/prisma");

cron.schedule('0 0 * * *', async () => {
  
  const ninetyDaysAgo = new Date();
  ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);

  try {
    const deletedUsers = await prisma.user.deleteMany({
      where: {
        deletedAt: {
          lt: ninetyDaysAgo, 
        },
      },
    });
    console.log(`ลบสำเร็จแล้ว ${deletedUsers.count} ผู้ใช้`);
  } catch (error) {
    console.error('เกิดข้อผิดพลาดระหว่างการล้างข้อมูล:', error);
  }
});
console.log('ลบ user หมดอายุทุกวัน 00:00 น.');