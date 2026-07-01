This PR updates multiple Helm charts to support configuring **multiple Gateway API `HTTPRoute` resources** via a new `httpRoutes` map, replacing the previous single `httpRoute` (and `extraHttpRoutes` where present). This is intended to allow defining multiple distinct routes per chart instance.

## Changes:

    * Replace `httpRoute` / `extraHttpRoutes` values with a new `httpRoutes` map in chart values.
    * Update `templates/httproute.yaml` to render one `HTTPRoute` per entry in `httpRoutes`.
    * Update Helm unittest fixtures to validate multiple rendered `HTTPRoute` documents and update `artifacthub.io/changes` notes.
