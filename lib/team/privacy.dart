import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightOrange,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'PRIVACY POLICY',
          style: TextStyle(
              fontSize: 38,
              color: purple,
              fontFamily: 'MyCustomFont',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
      ),
      body: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                height: 500,
                width: 400,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 248, 225),
                ),
                child: const Text(
                  '\nบริษัท ตั้งตี้ จำกัด (“บริษัท”) ขอแนะนำให้ท่านทำความเข้าใจนโยบายส่วนบุคคล (privacy policy) นี้ เนื่องจาก\n นโยบายนี้อธิบายถึงวิธีการที่บริษัทปฏิบัติต่อข้อมูลส่วนบุคคลของท่าน เช่น การเก็บรวบรวม การจัดเก็บรักษา การใช้ การเปิดเผย รวมถึงสิทธิต่างๆ ของท่าน เป็นต้น\n เพื่อให้ท่านได้รับทราบถึงนโยบายในการคุ้มครองข้อมูลส่วนบุคคลของบริษัท บริษัท ตระหนักถึงความสำคัญของการปกป้องข้อมูลส่วนบุคคลของลูกค้า พนักงาน รวมตลอดถึงคู่ค้าของบริษัท ด้วยเหตุนี้บริษัทจึงได้จัดให้มีมาตรการในการเก็บรักษา และป้องกันตามมาตราฐานของกฎหมาย ข้อกำหนด และระเบียบเกี่ยวกับการคุ้มครองข้อมูลส่วนบุคคล อย่างเคร่งครัด ดังต่อไปนี้ \n 1.ทางบริษัทจะไม่รับผิดชอบนอกเหนือจากขอบเขตของแอปพลิเคชัน\n 2.สามารถขอข้อมูลส่วนบุคคลของผู้กระทำผิดได้ โดยมีเงื่อนไขดังนี้\n  2.1 รูปภาพหลักฐานประกอบ\n  2.2 เอกสารที่ได้รับจากทางเจ้าหน้าที่ตำรวจ\n  2.3 สามารถแนบข้อมูลมาได้ที่ www.tungtee.co.th/report\n 3. ทางบริษัทจะไม่เปิดเผยข้อมูลส่วนบุคคลต่อสาธารณะ',
                  style: TextStyle(fontSize: 16, fontFamily: 'MyCustomFont'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
