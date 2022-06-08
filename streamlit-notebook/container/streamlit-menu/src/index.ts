import {
  JupyterFrontEnd,
  JupyterFrontEndPlugin,
} from '@jupyterlab/application';

import { ICommandPalette, MainAreaWidget } from '@jupyterlab/apputils';

import { FileDialog, IFileBrowserFactory } from '@jupyterlab/filebrowser';

import { TerminalManager } from '@jupyterlab/services';

import { Terminal } from '@jupyterlab/terminal';

import { LabIcon } from '@jupyterlab/ui-components';

import { showDialog, Dialog } from '@jupyterlab/apputils';

import streamlitSvg from '../style/assets/streamlit-icon.svg'

export const streamlitIcon = new LabIcon({
  name: 'barpkg:streamlit',
  svgstr: streamlitSvg
});

/**
 * Initialization data for the main menu example.
 */
const extension: JupyterFrontEndPlugin<void> = {
  id: 'streamlit-menu',
  autoStart: true,
  requires: [ICommandPalette, IFileBrowserFactory],
  activate: (app: JupyterFrontEnd, palette: ICommandPalette, browserFactory: IFileBrowserFactory) => {
    const { commands } = app;
    const command = 'jlab-odh:streamlit-menu';
    const commandSelect = 'jlab-odh:streamlit-select';
    let streamlitNextPort = 8501;

    // Streamlit launcher function
    async function launchStreamlit(filePath: String,) {
      let currentLocation = window.location.href;
      console.log(currentLocation);
      console.log(currentLocation.indexOf('/lab'));
      let mainLocation = currentLocation.slice(0, currentLocation.indexOf('/lab'));
      console.log(mainLocation);
      let streamlitLocation = mainLocation + '/proxy/' + streamlitNextPort + '/'
      console.log(streamlitLocation);
      let launchCommand = 'streamlit-launcher.sh -f ' + filePath + ' -p ' + streamlitNextPort + ' -s ' + streamlitLocation;
      console.log(launchCommand);

      const manager = new TerminalManager();
      const s1 = await manager.startNew();
      const term1 = new Terminal(s1, {
        initialCommand: `${launchCommand}`,
        shutdownOnClose: true
      });
      term1.title.closable = true;

      const widget = new MainAreaWidget({ content: term1 });
      widget.id = `jupyter-executor-${Date.now()}`;
      widget.title.label = 'Execute';
      widget.title.closable = true;

      if (!widget.isAttached) {
        // Attach the widget to the main work area if it's not there
        app.shell.add(widget, 'main');
      }

      // Activate the widget
      app.shell.activateById(widget.id);

      // Launch Streamlit in a new tab after 2 seconds
      // dot is a a fix for trailing slash being filtered
      setTimeout(() => {
        window.open(streamlitLocation + '.');
      }, 4000);

      // Increment port for next launch
      streamlitNextPort += 1;
    }

    commands.addCommand(commandSelect, {
      label: 'Select file to Streamlit...',
      caption: 'Select file to Streamlit...',
      execute: async (args: any) => {
        const manager = browserFactory.defaultBrowser.model.manager
        const dialog = FileDialog.getOpenFiles({
          manager, // IDocumentManager
          filter: model => model.type == 'file' // optional (model: Contents.IModel) => boolean
        });

        dialog.then(async result => {
          if (result.button.accept) {
            if (result.button.label === 'Select') {
              let files = result.value;
              if (files[0].path.endsWith('.py')) {
                launchStreamlit(files[0].path)
              }
              else {
                showDialog({
                  title: "Error",
                  body: 'You must select a Python file to be able to Streamlit it.',
                  buttons: [Dialog.okButton()],
                }).catch((e) => console.log(e));
              }
            } else {
              console.log('Cancelled');
            }
          }
        })
      },
    });

    // Add the command to the command palette
    const category = 'Extension Examples';
    palette.addItem({
      command,
      category,
      args: { origin: 'from the palette' },
    });

    // Add Context menu
    commands.addCommand('jlab-odh:streamlit-context', {
      label: 'Streamlit this file',
      caption: "Launch Streamlit with this file",
      icon: streamlitIcon,
      execute: () => {
        const file = browserFactory.tracker.currentWidget.selectedItems().next();
        launchStreamlit(file.path).catch((e) => console.log(e));
      },
    });
  },
};

export default extension;
