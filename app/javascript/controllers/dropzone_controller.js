import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];
  static outlets = ["image-preview"];

  dragOver(event) {
    event.preventDefault();
  }

  dragLeave(event) {
    event.preventDefault();
  }

  drop(event) {
    event.preventDefault();

    this.updateInputField(event.dataTransfer.files[0]);
    this.imagePreviewOutlet.show();
  }

  updateInputField(file) {
    const dataTransfer = new DataTransfer();

    dataTransfer.items.add(file);

    this.inputTarget.files = dataTransfer.files;
  }
}
