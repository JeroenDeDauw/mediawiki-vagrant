# == Class: role::multimediaviewer
# This role provisions the MultimediaViewer[https://www.mediawiki.org/wiki/Extension:MultimediaViewer] extension,
# which shows images and their metadata in a lightbox
# when the user clicks on the thumbnails.
class role::multimediaviewer {
    include ::role::multimedia
    include ::apache::mod::headers

    mediawiki::extension { 'MultimediaViewer':
        browser_tests => true,
    }

    apache::site_conf { 'Content-Disposition: attachment on ?download':
        site    => $mediawiki::wiki_name,
        content => template('role/content_disposition_attachment.conf.erb'),
    }
}
