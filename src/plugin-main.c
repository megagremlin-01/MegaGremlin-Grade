/*
MegaGremlin Grade
Copyright (C) <2026> <MegaGremlin> <megagremlin@megagremlin.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program. If not, see <https://www.gnu.org/licenses/>
*/

#include <obs-module.h>
#include <graphics/graphics.h>

OBS_DECLARE_MODULE()
OBS_MODULE_USE_DEFAULT_LOCALE("MegaGremlin-Grade", "en-US")

struct grading_data {
    obs_source_t *context;
    gs_effect_t  *effect;
    float        gain;
};

static const char *grading_get_name(void *unused) {
    return "MegaGremlin Grade";
}

static void grading_destroy(void *data) {
    struct grading_data *filter = (struct grading_data *)data;
    if (filter->effect) {
        gs_effect_destroy(filter->effect);
    }
    bfree(filter);
}

static void *grading_create(obs_data_t *settings, obs_source_t *context) {
    struct grading_data *filter = (struct grading_data *)bzalloc(sizeof(struct grading_data));
    char *char_path = obs_module_file("grading.hlsl");
    
    filter->context = context;
    filter->effect = gs_effect_create_from_file(char_path, NULL);
    bfree(char_path);

    if (!filter->effect) {
        blog(LOG_ERROR, "[MegaGremlin Grade] Shader failed to load!");
        grading_destroy(filter);
        return NULL;
    }

    return filter;
}

static void grading_update(void *data, obs_data_t *settings) {
    struct grading_data *filter = (struct grading_data *)data;
    filter->gain = (float)obs_data_get_double(settings, "gain");
}

static void grading_render(void *data, gs_effect_t *unused) {
    struct grading_data *filter = (struct grading_data *)data;
    obs_source_t *target = obs_filter_get_target(filter->context);

    if (!target || !filter->effect) {
        obs_source_skip_video_filter(filter->context);
        return;
    }

    gs_effect_set_float(gs_effect_get_param_by_name(filter->effect, "gain"), filter->gain);

    obs_source_process_filter_begin(filter->context, GS_RGBA, OBS_ALLOW_DIRECT_RENDERING);
    obs_source_process_filter_end(filter->context, filter->effect, 0, 0);
}

static obs_properties_t *grading_properties(void *data) {
    obs_properties_t *props = obs_properties_create();
    obs_properties_add_float_slider(props, "gain", "Gain", 0.0, 5.0, 0.01);
    return props;
}

static void grading_defaults(obs_data_t *settings) {
    obs_data_set_default_double(settings, "gain", 1.0);
}

struct obs_source_info grading_filter_info = {
    .id             = "megagremlin_grade",
    .type           = OBS_SOURCE_TYPE_FILTER,
    .output_flags   = OBS_SOURCE_VIDEO,
    .get_name       = grading_get_name,
    .create         = grading_create,
    .destroy        = grading_destroy,
    .update         = grading_update,
    .video_render   = grading_render,
    .get_properties = grading_properties,
    .get_defaults   = grading_defaults,
};

bool obs_module_load(void) {
    obs_register_source(&grading_filter_info);
    return true;
}