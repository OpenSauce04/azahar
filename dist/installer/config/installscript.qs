// The code in this script is kind of gross. Blame Qt for having poor and outdated documentation :^)

function Component() {
   installer.setMessageBoxAutomaticAnswer("OverwriteTargetDirectory", QMessageBox.Yes) // We have our own message box for this

   installer.currentPageChanged.connect(this,Component.prototype.onCurrentPageChanged)
   installer.installationStarted.connect(this,Component.prototype.onInstallationStarted)
   installer.installationFinished.connect(this,Component.prototype.onInstallationFinished)
}

// Display warning the first time the target directory is selected
var warningDisplayed = false
Component.prototype.onCurrentPageChanged = function() {
   if (arguments[0] == QInstaller.ComponentSelection && !warningDisplayed) {
      QMessageBox.information("OverwriteTargetDirectoryInfo", "Warning",
                              "Please be aware that the selected directory will be emptied before Lime3DS is installed into it.\n\nIf you have selected a custom directory, ensure that the path is correct and that there are no important files at the location.")
      warningDisplayed = true
   }
}

Component.deletePath = function() {
   installer.execute("rm", ["-rf", installer.value("TargetDir")+"/"+arguments[0]])
}

// Clear installation directory before starting
Component.prototype.onInstallationStarted = function() {
   Component.deletePath("")
}

// Somewhat hacky workaround for the Qt developers not allowing existing installs to be overwritten
// and not allowing the maintainance tool stuff to be excluded
Component.prototype.onInstallationFinished = function() {
   Component.deletePath("components.xml")
   Component.deletePath("installerResources")
   Component.deletePath("installer.dat")
   Component.deletePath("maintenancetool")
   Component.deletePath("maintenancetool.dat")
   Component.deletePath("maintenancetool.ini")
   Component.deletePath("network.xml")
}
