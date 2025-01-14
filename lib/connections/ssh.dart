import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_task2/components/LookAt.dart';
import 'package:lg_task2/components/kml_entity.dart';
import 'package:lg_task2/components/screen_overlay_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'package:path_provider/path_provider.dart';
// import 'package:ssh/ssh.dart';
import 'package:flutter/services.dart' show rootBundle;

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _password;
  late String _numberOfRigs;
  late SSHClient? _client;

  bool logo = false;

  // final String _url = 'http://lg1:81';

  Future<void> initConnectionState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('port') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _password = prefs.getString('password') ?? '123';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool> connectToLG() async {
    await initConnectionState();
    try {
      final SSHSocket socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _password,
      );
      return true;
    } on SocketException catch (e) {
      developer.log('Error in Connecting ss: $e');
      return false;
    }
  }

  Future<void> tester() async {
    try {
      if (_client == null) {
        developer.log('SSH client is not initialized.');
        return;
      }
      await _client!.execute('echo "search=India" > /tmp/query.txt');
      return;
    } catch (e) {
      developer.log('Error in sending signal: $e');
      return;
    }
  }

  Future<void> clearKml() async {
    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

    for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
      String blankKml = KMLEntity.generateBlank('slave_$i');
      query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
    }

    if (logo) {
      final kml = KMLEntity(
        name: 'SVT-logos',
        content: '<name>Logos</name>',
        screenOverlay: ScreenOverlayEntity.logos().tag,
      );

      query +=
          " && echo '${kml.body}' > /var/www/html/kml/slave_$logoScreen.kml";
    }

    if (_client == null) {
      await connectToLG();
    }
    await _client!.execute(query);
  }

  Future<void> reboot() async {
    for (var i = int.parse(_numberOfRigs); i >= 1; i--) {
      try {
        await _client!.execute(
            'sshpass -p $_password ssh -t lg$i "echo $_password | sudo -S reboot"');
      } catch (e) {
        developer.log('$e');
      }
    }
  }

  /// Relaunches the Liquid Galaxy system.
  Future<void> relaunch() async {
    final pw = _password;
    final user = _username;

    for (var i = int.parse(_numberOfRigs); i >= 1; i--) {
      try {
        final relaunchCommand = """RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  echo $pw | sudo -S service \\\${SERVICE} start
else
  echo $pw | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p $pw ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        if (_client == null) {
          await connectToLG();
        }
        await _client!
            .execute('"/home/$user/bin/lg-relaunch" > /home/$user/log.txt');
        await _client!.execute(relaunchCommand);
      } catch (e) {
        developer.log("$e");
      }
    }
  }

  int get logoScreen {
    if (int.parse(_numberOfRigs) == 1) {
      return 1;
    }
    // return 1; /*Debugging only when using 1 screen*/
    return (int.parse(_numberOfRigs) / 2).floor() + 2;
  }

  Future<void> setLogos({
    String name = 'SVT-logos',
    String content = '<name>Logos</name>',
  }) async {
    final screenOverlay = ScreenOverlayEntity.logos();

    final kml = KMLEntity(
      name: name,
      content: content,
      screenOverlay: screenOverlay.tag,
    );

    try {
      await sendKMLToSlave(logoScreen, kml.body);
      logo = true;
    } catch (e) {
      developer.log("$e");
    }
  }

  Future<void> sendKMLToSlave(int screen, String content) async {
    try {
      await _client!
          .execute("echo '$content' > /var/www/html/kml/slave_$screen.kml");
    } catch (e) {
      developer.log("$e");
    }
  }

  Future<void> cleanLogos({
    String name = 'SVT-logos',
    String content = '<name>Logos</name>',
  }) async {
    final kml = KMLEntity(
      name: name,
      content: content,
    );

    try {
      await sendKMLToSlave(logoScreen, kml.body);
      logo = false;
    } catch (e) {
      developer.log("$e");
    }
  }

  Future<void> displaySpecificKML(String name) async {
    String filePath = 'assets/kml_files/$name.kml';

    try {
      final kmlContent = await rootBundle.loadString(filePath);
      final localFile = await makeFile(name, kmlContent);
      developer.log("Made File");
      await printKMLFileContent(name.replaceAll(' ', '_'));
      await uploadKMLFile(localFile, name.replaceAll(' ', '_'));
      developer.log("Uploaded");
    } catch (e) {
      developer.log('Error: $e');
    }
  }

  Future<File?> makeFile(String filename, String content) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      String sanitizedFilename = filename.replaceAll(' ', '_');
      File localFile = File('${localPath.path}/$sanitizedFilename.kml');
      await localFile.writeAsString(content);
      return localFile;
    } catch (e) {
      developer.log("Error creating file: $e");
      return null;
    }
  }

  Future<void> printKMLFileContent(String filename) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      File localFile = File('${localPath.path}/$filename.kml');
      if (await localFile.exists()) {
        String fileContent = await localFile.readAsString();
        developer.log("Content of $filename.kml:");
        developer.log(fileContent);
      } else {
        developer.log("File $filename.kml does not exist.");
      }
    } catch (e) {
      developer.log("Error reading file: $e");
    }
  }

  Future<void> uploadKMLFile(File? inputFile, String kmlName) async {
    if (inputFile == null) {
      developer.log("Input file is null");
      return;
    }
    try {
      await connectToLG();

      final sftp = await _client!.sftp();
      final file = await sftp.open('/var/www/html/$kmlName.kml',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);

      var bytes = await inputFile.readAsBytes();

      file.writeBytes(bytes);

      await _client!.execute(
          "echo 'http://lg1:81/$kmlName.kml' >> /var/www/html/kmls.txt");

      LookAt flyto = LookAt(
        -118.2199411,
        34.1470753,
        '${(75208.9978371 / int.parse(_numberOfRigs)) * 6}',
        '45',
        '0',
      );
      if (_client == null) {
        await connectToLG();
      }
      await _client!.execute(
          'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt');
    } catch (e) {
      developer.log("Error uploading file: $e");
    }
  }
}
